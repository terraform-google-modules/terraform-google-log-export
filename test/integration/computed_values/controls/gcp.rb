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

log_export_map   = attribute('log_export_map')
destination_map  = attribute('destination_map')

control "gcp" do
  title "Log exports - testing computed values for sink_parent_id and project"

  describe google_storage_bucket(
    name: destination_map["resource_names"]
  ) do
    it { should exist }
  end

  describe google_logging_project_sink(
    project: log_export_map["parent_id"],
    sink: log_export_map["sink_resource_names"][0]
  ) do
    it { should exist }
    its('destination') { should eq destination_map["destination_uris"][0] }
    its('filter') { should eq log_export_map["filters"][0] }
    its('writer_identity') { should eq log_export_map["writer_identities"][0] }
  end

  describe google_storage_bucket_iam_binding(
    bucket: destination_map["resource_names"][0],
    role: "roles/storage.objectCreator",
  ) do
    it { should exist }
    its('members') { should include log_export_map["writer_identities"][0] }
  end
end
