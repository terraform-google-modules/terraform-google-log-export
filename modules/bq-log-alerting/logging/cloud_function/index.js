/*
Copyright 2020 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

const {BigQuery} = require('@google-cloud/bigquery');
const {SecurityCenterClient} = require('@google-cloud/security-center')
const MD5 = require('crypto-js/md5');

const bigquery = new BigQuery();
// These constants will need to be tuned to your preference
const project = process.env.LOGGING_PROJECT;
const dataset_name = 'views';
const invocation_name = 'securityalert_invocation';
const result_name = 'securityalert_result';
const source_name = process.env.CSCC_SOURCE;
const dry_run = (process.env.DRY_RUN === 'true');

function createFindingObject (source_name, labels) {
  const eventTime = new Date(labels.eventTimestamp.value).getTime();
  const sourceProperties = {};
  for (const key in labels) {
    if (key !== 'eventTimestamp' &&
        key !== 'resourceName' &&
        key !== 'query') {
      sourceProperties[key] = { stringValue: "" + labels[key] };
    }
  }
  return {
    parent: "" + source_name,
    findingId: MD5("" + labels.query + labels.eventTimestamp + labels.callerIp + labels.principalEmail + labels.resourceName),
    finding: {
      state: 'ACTIVE',
      // Resource the finding is associated with.  This is an
      // example any resource identifier can be used.
      resourceName: labels.resourceName,
      // A free-form category.
      category: "" + labels.query,
      // The time associated with discovering the issue.
      eventTime: {
        seconds: Math.floor(eventTime / 1000),
        nanos: (eventTime % 1000) * 1e6,
      },
      sourceProperties: sourceProperties
    }
  }
}

async function createFinding(cscc_client, source_name, labels) {
  try {
    finding = createFindingObject(source_name, labels)
    if (dry_run) {
      console.log('DRY_RUN: scc finding: ', JSON.stringify(finding));
    } else {
      const [newFinding] = await cscc_client.createFinding(finding);
    }
    return 1;
  } catch (err) {
    let errorMsg = "" + err;
    if (!errorMsg.includes("6 ALREADY_EXISTS")) {
      throw new Error(errorMsg);
    } else {
      console.log("createFinding: " + errorMsg);
    }
  }
  return 0;
}

async function createFindingsFromResult(cscc_client, source_name, tableName, result) {
  let count = 0;
  for (var i = 0; i < result.length; i++) {
    const res = result[i];
    const labels = { query: tableName };
    for (var j = 0; j < res.length; j++) {
      const row = res[j];
      for (var key in row) {
        if (row.hasOwnProperty(key)) {
          if (key !== 'receiveTimestamp') {
            labels[key] = row[key];
          } else {
            // receiveTimestamp is returned as a complex type.
            labels[key] = row[key]['value'];
          }
        }
      }
      if (labels.hasOwnProperty('resourceName')) {
        count += await createFinding(cscc_client, source_name, labels);
      }
    }
  }
  return count;
}

exports.cronPubSub = async function (event, context, callback) {
    const cscc_client = new SecurityCenterClient();
    const pubsubMessage = event;
    const payload = JSON.parse(Buffer.from(pubsubMessage.data, 'base64').toString()||'{}');
    const payloadQuantity = payload ? payload.quantity : '';
    const attributeQuantity = pubsubMessage.attributes ? pubsubMessage.attributes.quantity : '';
    const quantity = parseInt(payloadQuantity ? payloadQuantity : (attributeQuantity ? attributeQuantity : 1));
    const payloadUnit = payload ? payload.unit : '';
    const attributeUnit = pubsubMessage.attributes ? pubsubMessage.attributes.unit : '';
    const unit = payloadUnit ? payloadUnit : (attributeUnit ? attributeUnit : 'HOUR');
    const createTime = new Date();

    if (!Number.isInteger(quantity)) {
      throw new Error(`Quantity ${quantity} is not an integer.`);
    }
    if (unit !== 'MICROSECOND' && unit !== 'MILLISECOND' && unit !== 'SECOND' && unit !== 'MINUTE' && unit !== 'HOUR'){
      throw new Error(`Unit ${unit} is not in valid list (see docs for BigQuery standard SQL)`);
    }

    console.log('quantity: ' + quantity + ' unit: '+ unit);

    const dataset = bigquery.dataset(dataset_name);
    const data = await dataset.getTables();

    const table_ids = data[0].map(table => table.id);
    let findingCount = 0;
    for (var i = 0; i < table_ids.length; i++) {
      const table_name = table_ids[i];
      var query_str = 'SELECT * FROM `' + `${project}.${dataset_name}.${table_name}`;
      query_str += '` WHERE receiveTimestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL ';
      query_str += `${quantity} ${unit}` + ");";
      console.log(query_str);
      var config_obj = { query: query_str, useLegacySql: false };
      try {
        const result = await bigquery.query(config_obj);
        findingCount += await createFindingsFromResult(cscc_client, source_name, table_name, result);
      } catch (err) {
        console.error("" + err);
        throw new Error("" + err);
      }
    }
    if (findingCount == 0) {
      console.log('No new findings');
    } else {
      console.log(findingCount + ' new findings');
    }
    console.log("Successfully wrote metrics for all tables.");
    callback();
};
