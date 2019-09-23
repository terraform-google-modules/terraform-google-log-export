#!/usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "#!/usr/bin/env bash" > ../source.sh

project_id=$(terraform output project_id)
sa_json=$(terraform output sa_key)
parent_resource_folder=$(terraform output parent_resource_folder)
parent_resource_billing_account=$(terraform output parent_resource_billing_account)
parent_resource_organization=$(terraform output parent_resource_organization)

# shellcheck disable=SC2086,SC2154
{ echo "export TF_VAR_project_id='$project_id'"; \
echo "export TF_VAR_parent_resource_project='$project_id'"; \
echo "export TF_VAR_parent_resource_folder='$parent_resource_folder'"; \
echo "export TF_VAR_parent_resource_billing_account='$parent_resource_billing_account'"; \
echo "export TF_VAR_parent_resource_organization='$parent_resource_organization'"; \
echo "export SERVICE_ACCOUNT_JSON='$(echo $sa_json | base64 --decode)'"; }  >> ../source.sh
