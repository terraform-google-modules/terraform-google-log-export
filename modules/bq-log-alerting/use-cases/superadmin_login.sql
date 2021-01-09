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
  timestamp AS eventTimestamp,
  receiveTimestamp,
  log_table.insertId,
  log_table.protopayload_auditlog.serviceName,
  log_table.protopayload_auditlog.requestmetadata.callerip AS callerIp,
  log_table.protopayload_auditlog.authenticationinfo.principalemail AS principalEmail,
  log_table.protopayload_auditlog.resourceName,
  log_table.protopayload_auditlog.methodname as methodName
FROM `${project}.${dataset}.cloudaudit_googleapis_com_data_access_*` as log_table
WHERE protopayload_auditlog.authenticationinfo.principalemail IN
  (
    '<user1>@<domain>',
    '<user2>@<domain>'
  )
AND protopayload_auditlog.methodname IN
  (
    'google.login.LoginService.loginSuccess',
    'google.login.LoginService.loginVerification',
    'google.login.LoginService.loginFailure',
    'google.login.LoginService.loginSuspicious'
  );
