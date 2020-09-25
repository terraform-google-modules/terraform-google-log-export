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

WITH parsed_ips AS (
  SELECT
    log_table.receiveTimestamp,
    log_table.timestamp,
    log_table.jsonPayload.requestmetadata.callerip,
    NET.SAFE_IP_FROM_STRING(jsonPayload.requestmetadata.callerip) AS parsed_ip,
    log_table.jsonPayload.authenticationinfo.principalemail,
    log_table.jsonPayload.methodname
  FROM
    `${project}.${dataset}.login_*` AS log_table
)
SELECT
  receiveTimestamp,
  timestamp AS eventTimestamp,
  callerip,
  principalemail,
  methodName,
  NULL AS resourceName
FROM
  parsed_ips
WHERE
  (
    (
      NET.IP_TRUNC(parsed_ip, 16) != b"\xC0\xA8\x00\x00"
    ) # 192.168.0.0/16 private range.
  )
  OR callerip IS NULL
  OR BYTE_LENGTH(parsed_ip) = 16;