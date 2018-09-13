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

# Example of a org-level sink to a BigQuery dataset
module "org_sink" {
  source = "../../"
  name   = "test-org-sink-bigquery"
  org_id = "${var.org_id}"
  filter = "severity > WARNING"

  bigquery = {
    name    = "org_sink"
    project = "${var.project_id}"
  }
}

# Example of a folder-level sink to a BigQuery dataset
# Note that this uses a root-level folder, but can be applied with any nested
# folder. 
data "google_active_folder" "folder" {
  display_name = "${var.folder_name}"
  parent       = "organizations/${var.org_id}"
}

module "folder_sink" {
  source = "../../"
  name   = "test-folder-sink-bigquery"
  folder = "${data.google_active_folder.folder.name}"
  filter = "severity > WARNING"

  bigquery = {
    name    = "folder_sink"
    project = "${var.project_id}"
  }
}

# Example of a project-level sink to a BigQuery dataset
module "project_sink" {
  source  = "../../"
  name    = "test-project-sink-bigquery"
  project = "${var.project_id}"

  bigquery = {
    name    = "project_sink"
    project = "${var.project_id}"
  }
}
