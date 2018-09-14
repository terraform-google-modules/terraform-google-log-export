/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  credentials = "${file(var.credentials_path)}"
}

# Example of an folder-level sink to a Pub/Sub topic
module "pubsub-sink" {
  source = "../../"
  name   = "test-folder-sink-pubsub"
  folder = "${var.folder_id}"
  filter = "severity > WARNING"

  pubsub = {
    name              = "pubsub-folder-sink"
    project           = "${var.destination_project_id}"
    create_subscriber = true
  }
}

# Example of a folder-level sink to a Cloud Storage bucket
module "storage-sink" {
  source = "../../"
  name   = "test-folder-sink-gcs"
  folder = "${var.folder_id}"
  filter = "logName = /logs/cloudaudit.googleapis.com"

  storage = {
    name    = "${var.gcs_bucket_name}-folder-sink"
    project = "${var.destination_project_id}"
  }
}

# Example of a folder-level sink to a igQuery dataset
module "bigquery-sink" {
  source = "../../"
  name   = "test-folder-sink-bigquery"
  folder = "${var.folder_id}"
  filter = "resource.type = gce_instance"

  bigquery = {
    name    = "folder_sink"
    project = "${var.destination_project_id}"
  }
}
