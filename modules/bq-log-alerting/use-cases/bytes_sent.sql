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

SELECT
  CURRENT_TIMESTAMP() AS receiveTimestamp,
  NULL AS principalEmail,
  resourceName,
  callerIp,
  dest_ip AS destination_ip,
  bytes_sent
FROM
  (
    SELECT
      CONCAT(
        'projects/',
        jsonPayload.src_vpc.project_id,
        '/zones/',
        jsonPayload.src_instance.zone,
        '/vm/',
        jsonPayload.src_instance.vm_name
      ) AS resourceName,
      jsonPayload.connection.src_ip AS callerIp,
      jsonPayload.connection.dest_ip AS dest_ip,
      SUM(CAST(jsonPayload.bytes_sent AS FLOAT64)) AS bytes_sent
    FROM
      `${project}.${dataset}.compute_googleapis_com_vpc_flows_*`
    WHERE
      jsonPayload.src_instance.vm_name IS NOT NULL
      AND NOT (
        NET.IP_TRUNC(
          NET.SAFE_IP_FROM_STRING(jsonPayload.connection.dest_ip),
          8
        ) = b"\x0A\x00\x00\x00" # 10.0.0.0/8 private range.
        OR NET.IP_TRUNC(
          NET.SAFE_IP_FROM_STRING(jsonPayload.connection.dest_ip),
          12
        ) = b"\xAB\x10\x00\x00" # 172.16.0.0/12 private range.
        OR NET.IP_TRUNC(
          NET.SAFE_IP_FROM_STRING(jsonPayload.connection.dest_ip),
          16
        ) = b"\xC0\xA8\x00\x00" # 192.168.0.0/16 private range.
        OR NET.IP_TRUNC(
          NET.SAFE_IP_FROM_STRING(jsonPayload.connection.dest_ip),
          22
        ) = b"\x82\xD3\x00\x00" # 130.211.0.0/22 GLB range.
        OR NET.IP_TRUNC(
          NET.SAFE_IP_FROM_STRING(jsonPayload.connection.dest_ip),
          16
        ) = b"\x23\xBF\x00\x00" # 35.191.0.0/16 GLB range.
      )
      AND receiveTimestamp >= TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL -1 DAY)
    GROUP BY
      jsonPayload.src_instance.vm_name,
      jsonPayload.connection.src_ip,
      jsonPayload.connection.dest_ip,
      jsonPayload.src_vpc.project_id,
      jsonPayload.src_instance.zone
  )
WHERE
  bytes_sent > 1E9;
