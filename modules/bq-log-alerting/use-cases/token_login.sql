# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

WITH log_table AS (
  SELECT
    ANY_VALUE(
      IF(
        parameters.name = "client_id",
        parameters.value,
        NULL
      )
    ) AS client_id,
    ANY_VALUE(
      IF(
        parameters.name = "app_name",
        parameters.value,
        NULL
      )
    ) AS app_name,
    MAX(receiveTimestamp) AS receiveTimestamp,
    callerIp,
    principalEmail,
    project_id AS resourceName,
    TIMESTAMP_SECONDS(CAST(eventEpochTime AS INT64)) AS eventTimestamp
  FROM
    (
      SELECT
        insertId,
        logName,
        parameters,
        receiveTimestamp,
        jsonPayload.authenticationinfo.principalemail,
        resource.labels.project_id,
        jsonPayload.requestmetadata.callerip,
        jsonPayload.report_timestamp.seconds AS eventEpochTime
      FROM
        `${project}.${dataset}.token_*`,
        UNNEST(jsonPayload.parameters) AS parameters
    )
  GROUP BY
    insertId,
    logName,
    eventTimestamp,
    callerip,
    principalemail,
    project_id
)

SELECT
  *
FROM
  log_table
WHERE
  app_name != "gsuite log exporter"
  AND principalEmail IN ('<user>@<domain>');