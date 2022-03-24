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

log_export_map   = attribute('log_export_map')
destination_map  = attribute('destination_map')

control "gcp" do
  title "Log exports - project level pubsub destination - native resources"

  describe google_pubsub_topic(
    project: destination_map[:project],
    name: destination_map[:resource_name],
  ) do
    it { should exist }
  end

  describe google_logging_project_sink(
    project: log_export_map[:parent_resource_id],
    name: log_export_map[:log_sink_resource_name]
  ) do
    it { should exist }
    its('destination') { should eq destination_map[:destination_uri] }
    its('filter') { should eq log_export_map[:filter] }
    its('writer_identity') { should eq log_export_map[:writer_identity] }
  end
end
