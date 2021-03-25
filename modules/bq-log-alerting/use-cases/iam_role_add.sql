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
  receiveTimestamp,
  timestamp AS eventTimestamp,
  protopayload_auditlog.requestMetadata.callerIp,
  protopayload_auditlog.authenticationInfo.principalEmail,
  protopayload_auditlog.resourceName as resource_name,
  protopayload_auditlog.serviceName,
  CONCAT('//', protopayload_auditlog.serviceName, '/projects/', resource.labels.project_id) as resourceName,
  bindings.role,
  bindings.member,
  insertId
FROM
  `${project}.${dataset}.cloudaudit_googleapis_com_activity_*`
  CROSS JOIN UNNEST(
    protopayload_auditlog.servicedata_v1_iam.policyDelta.bindingDeltas
  ) AS bindings
WHERE
  protopayload_auditlog.methodName = 'SetIamPolicy'
  AND bindings.action = 'ADD'
  AND JSON_EXTRACT(
    TO_JSON_STRING(
      protopayload_auditlog.servicedata_v1_iam.policyDelta
    ),
    '$.bindingDeltas[0].member'
  ) NOT LIKE '%domain1.com%'
  AND JSON_EXTRACT(
    TO_JSON_STRING(
      protopayload_auditlog.servicedata_v1_iam.policyDelta
    ),
    '$.bindingDeltas[0].member'
  ) NOT LIKE '%domain2.com%';
