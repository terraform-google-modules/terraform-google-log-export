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

pubsub_topic_name = attribute('pubsub_topic_name')
source_name = attribute('source_name')
cf_service_account_email = attribute('cf_service_account_email')
logging_project = attribute('logging_project')
dry_run = attribute('dry_run') ? 'true' : 'false'
function_region = attribute('function_region')
org_id = attribute('org_id')

project_role = 'roles/bigquery.admin'
org_role = 'roles/securitycenter.findingsEditor'

org_name = "organizations/#{org_id}"

bigquery_dataset = 'views'

cf_name = 'generate-alerts'

control 'gcp' do
  title 'Big Query Log Alerting'

  describe google_service_account(
    project: logging_project,
    name: cf_service_account_email
  ) do
    it { should exist }
  end

  describe google_project_iam_binding(
    project: logging_project,
    role: project_role
  ) do
    it { should exist }
    its('members') { should include "serviceAccount:#{cf_service_account_email}" }
  end

  describe google_organization_iam_binding(
    name: org_name,
    role: org_role
  ) do
    it { should exist }
    its('members') { should include "serviceAccount:#{cf_service_account_email}" }
  end

  describe google_bigquery_dataset(
    project: logging_project,
    name: bigquery_dataset
  ) do
    it { should exist }
    its('description') { should eq 'Log view dataset' }
  end

  describe google_cloudfunctions_cloud_function(
    project: logging_project,
    location: function_region,
    name: cf_name
  ) do
    it { should exist }
    its('description') { should eq 'read from BQ view to generate alerts' }
    its('timeout') { should eq '540s' }
    its('available_memory_mb') { should eq 256 }
    its('runtime') { should eq 'nodejs20' }
    its('environment_variables') {
      should include(
        'CSCC_SOURCE' => source_name,
        'LOGGING_PROJECT' => logging_project,
        'DRY_RUN' => dry_run
      )
    }
  end

  describe google_pubsub_topic(
    project: logging_project,
    name: pubsub_topic_name
  ) do
    it { should exist }
  end
end
