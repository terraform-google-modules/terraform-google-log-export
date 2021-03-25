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
  insertId,
  receiveTimestamp,
  timestamp AS eventTimestamp,
  protopayload_auditlog.requestMetadata.callerIp,
  protopayload_auditlog.authenticationInfo.principalEmail,
  protopayload_auditlog.resourceName,
  protopayload_auditlog.methodName,
  CASE ARRAY_LENGTH(protopayload_auditlog.authenticationInfo.serviceAccountDelegationInfo)
    WHEN 0 THEN "No Impersonation"
  ELSE
  protopayload_auditlog.authenticationInfo.serviceAccountDelegationInfo[
OFFSET
  (0)].firstPartyPrincipal.principalEmail
END
  AS originalPrincipalEmail
FROM
  `${project}.${dataset}.cloudaudit_googleapis_com_activity_*`
WHERE
  protopayload_auditlog.authenticationInfo.principalEmail = "<TERRAFORM_SERVICE_ACCOUNT_EMAIL>"
  AND ((ARRAY_LENGTH(protopayload_auditlog.authenticationInfo.serviceAccountDelegationInfo) > 0
      AND "<CICD_SERVICE_ACCOUNT_EMAIL>" NOT IN (
      SELECT
        firstPartyPrincipal.principalEmail
      FROM
        UNNEST(protopayload_auditlog.authenticationInfo.serviceAccountDelegationInfo)))
    OR ((ARRAY_LENGTH(protopayload_auditlog.authenticationInfo.serviceAccountDelegationInfo) = 0)
      AND NOT operation.last = TRUE)
    OR protopayload_auditlog.authenticationInfo.serviceAccountKeyName IS NOT NULL)
