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


WITH parsed_ips AS (
  SELECT
    insertId,
    receiveTimestamp,
    timestamp AS eventTimestamp,
    NET.SAFE_IP_FROM_STRING(jsonPayload.connection.src_ip) AS src_ip_parsed,
    NET.SAFE_IP_FROM_STRING(jsonPayload.connection.dest_ip) AS dest_ip_parsed,
    jsonPayload.connection.src_ip,
    jsonPayload.connection.src_port,
    jsonPayload.connection.dest_ip,
    jsonPayload.connection.dest_port,
    jsonPayload.connection.protocol
  FROM
    `${project}.${dataset}.compute_googleapis_com_vpc_flows_*`
)
SELECT
  receiveTimestamp,
  eventTimestamp,
  src_ip AS callerIp,
  insertId,
  # We need to keep the metric labels the same across queries.
  NULL AS principalEmail,
  dest_ip AS resourceName
FROM
  parsed_ips
WHERE
  BYTE_LENGTH(src_ip_parsed) = 16 # Is an IPv6 address.
  OR NOT(
    NET.IP_TRUNC(src_ip_parsed, 8) = b"\x0A\x00\x00\x00" # 10.0.0.0/8 private range.
    OR NET.IP_TRUNC(src_ip_parsed, 12) = b"\xAB\x10\x00\x00" # 172.16.0.0/12 private range.
    OR NET.IP_TRUNC(src_ip_parsed, 16) = b"\xC0\xA8\x00\x00" # 192.168.0.0/16 private range.
    OR NET.IP_TRUNC(src_ip_parsed, 22) = b"\x82\xD3\x00\x00" # 130.211.0.0/22 GLB range.
    OR NET.IP_TRUNC(src_ip_parsed, 16) = b"\x23\xBF\x00\x00" # 35.191.0.0/16 GLB range.
  )
LIMIT
  50; # Currently implemented to limit the noisy results
