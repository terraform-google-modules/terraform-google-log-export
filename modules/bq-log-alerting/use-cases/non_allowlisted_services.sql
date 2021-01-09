# Copyright 2020 Google LLC
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
    receiveTimestamp,
    timestamp,
    protopayload_auditlog.requestMetadata.callerIp AS callerIp,
    protopayload_auditlog.authenticationInfo.principalEmail AS principalEmail,
    logName,
    log.insertId,
    log.resource.labels.project_id AS projectId,
    REGEXP_EXTRACT(authInfo.resource,'services/([^/]*)') AS serviceName
  FROM
    `${project}.${dataset}.cloudaudit_googleapis_com_activity_*` log,
    UNNEST(protopayload_auditlog.authorizationInfo) AS authInfo
  WHERE
    protopayload_auditlog.methodName IN (
      "google.api.servicemanagement.v1.ServiceManager.ActivateServices",
      "google.api.serviceusage.v1.ServiceUsage.EnableService",
      "google.api.serviceusage.v1.ServiceUsage.BatchEnableServices"
    ) # Filter out IPv6 addresses, was receiving a double result for each enable event
    AND NET.SAFE_IP_FROM_STRING(protopayload_auditlog.requestMetadata.callerIp)
       != b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01"
)

SELECT
  DISTINCT receiveTimestamp,
  timestamp AS eventTimestamp,
  callerIp,
  CONCAT('//', serviceName, '/projects/', projectId) as resourceName,
  principalEmail,
  insertId,
  serviceName
FROM
  log_table
WHERE
  serviceName IS NOT NULL
  AND NOT REGEXP_CONTAINS(
    serviceName,
    'dns.googleapis.com|iap.googleapis.com|compute.googleapis.com|file.googleapis.com|stackdriver.googleapis.com'
  );
