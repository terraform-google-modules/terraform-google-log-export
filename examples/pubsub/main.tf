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

# Example of an organization-level sink to Pub/Sub topic
module "org_sink" {
  source = "../../"
  name   = "test-org-sink-pubsub"
  org_id = "${var.org_id}"
  filter = "severity > WARNING"

  pubsub = {
    name    = "org-sink"
    project = "${var.destination_project_id}"
  }
}

# Example of a folder-level sink to Pub/Sub topic
data "google_active_folder" "folder" {
  display_name = "${var.folder_name}"
  parent       = "organizations/${var.org_id}"
}

module "folder_sink" {
  source = "../../"
  name   = "test-folder-sink-pubsub"
  folder = "${data.google_active_folder.folder.name}"
  filter = "severity > WARNING"

  pubsub = {
    name    = "folder-sink"
    project = "${var.project_id}"
  }
}

# Example of a project-level sink to Pub/Sub topic
module "project_sink" {
  source                 = "../../"
  name                   = "test-project-sink-pubsub"
  project                = "${var.project_id}"
  unique_writer_identity = true

  pubsub = {
    name              = "project-sink"
    project           = "${var.project_id}"
    create_subscriber = true
  }
}
