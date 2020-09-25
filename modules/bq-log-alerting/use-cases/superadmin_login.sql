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

SELECT
  MAX(receiveTimestamp),
  TIMESTAMP_SECONDS(CAST(log_table.jsonPayload.report_timestamp.seconds AS INT64)) AS eventTimestamp,
  log_table.jsonPayload.requestmetadata.callerIp AS callerIp,
  log_table.jsonPayload.authenticationinfo.principalEmail AS principalEmail,
  NULL AS resourceName,
  log_table.jsonPayload.methodName AS methodName
FROM
  `${project}.${dataset}.login_*` AS log_table
WHERE
  jsonPayload.authenticationinfo.principalemail IN (
    'superadmin1@company.com',
    'superadmin2@company.com'
  )
  AND jsonPayload.methodname IN (
    'login_success',
    'login_verification',
    'login_failure',
    'login_suspicious'
  )
GROUP BY eventTimestamp, callerIp, principalEmail, methodName;