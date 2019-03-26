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

control "gcloud" do
  title "Log exports - project level pubsub destination - gcloud commands"

  describe command("gcloud beta pubsub topics get-iam-policy #{destination_map['resource_name']} --project #{destination_map['project']} --format json") do
    its('exit_status') { should eq 0 }
    its('stderr') { should eq '' }
    let(:bindings) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true)[:bindings]
      else
        []
      end
    end

    it "does include #{log_export_map['writer_identity']} in the roles/pubsub.publisher IAM binding" do
      expect(bindings).to include(
        members: including("#{log_export_map['writer_identity']}"),
        role: "roles/pubsub.publisher"
      )
    end
  end
end
