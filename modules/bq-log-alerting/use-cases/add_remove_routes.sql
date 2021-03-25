# Copyright 2020 Google Inc.
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
    log_table.receiveTimestamp,
    log_table.timestamp AS eventTimestamp,
    log_table.protopayload_auditlog.requestMetadata.callerIp,
    log_table.protopayload_auditlog.authenticationInfo.principalEmail,
    log_table.protopayload_auditlog.serviceName,
    log_table.resource.labels.project_id,
    CONCAT('//', log_table.protopayload_auditlog.serviceName, '/projects/', log_table.resource.labels.project_id, '/global/routes/', log_table.resource.labels.route_id) as resourceName,
    log_table.insertId
FROM
    `${project}.${dataset}.cloudaudit_googleapis_com_activity_*` AS log_table
WHERE
    log_table.resource.type = 'gce_route'
    AND log_table.operation.last = TRUE # Route insertion can be a long-running operation, so this prevents us from double-counting.
    AND log_table.protopayload_auditlog.methodName IN (
        'v1.compute.routes.insert',
        'beta.compute.routes.insert',
        'v1.compute.routes.delete',
        'beta.compute.routes.delete'
    );
