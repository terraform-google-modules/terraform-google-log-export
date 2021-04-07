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

cloud_scheduler_job_name = attribute('cloud_scheduler_job_name')
org_id = attribute('org_id')
logging_project = attribute('logging_project')
function_region = attribute('function_region')
pubsub_topic_name = attribute('pubsub_topic_name')
job_schedule = attribute('job_schedule')
source_name = attribute('source_name')

job_name = 'bq-alerts-event-trigger'
complete_job_name = "projects/#{logging_project}/locations/#{function_region}/jobs/#{job_name}"

topic_name = "projects/#{logging_project}/topics/#{pubsub_topic_name}"

control 'gcloud' do
  title 'Big Query Log Alerting - gcloud commands'

  describe command("gcloud alpha scc sources describe #{org_id} --source=#{source_name} --format json") do
    its('exit_status') { should eq 0 }
    its('stderr') { should eq '' }
    let(:data) do
      if subject.exit_status.zero?
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it 'has correct name' do
      expect(data).to include(
        'name' => source_name
      )
    end

    it 'has correct displayName' do
      expect(data).to include(
        'displayName' => 'BQ Log Alerts'
      )
    end
  end

  describe command("gcloud scheduler jobs describe #{job_name} --project=#{logging_project} --format json") do
    its('exit_status') { should eq 0 }
    its('stderr') { should eq '' }
    let(:data) do
      if subject.exit_status.zero?
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "has correct name #{complete_job_name}" do
      expect(data).to include(
        'name' => complete_job_name
      )
    end

    it "has correct topicName #{topic_name}" do
      expect(data['pubsubTarget']).to include(
        'topicName' => topic_name
      )
    end

    it "has correct schedule #{job_schedule}" do
      expect(data).to include(
        'schedule' => job_schedule
      )
    end
  end
end
