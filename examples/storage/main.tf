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

# Example of a org-level sink to a Cloud Storage bucket
module "org_sink" {
  source = "../../"
  name   = "test-org-sink-gcs"
  org_id = "${var.org_id}"
  filter = "severity > WARNING"

  storage = {
    name    = "${var.gcs_bucket_prefix}-org-sink-${var.gcs_bucket_suffix}"
    project = "${var.project_name}"
  }
}

# Example of a folder-level sink to a Cloud Storage bucket
data "google_active_folder" "folder" {
  display_name = "${var.folder_name}"
  parent       = "organizations/${var.org_id}"
}

module "folder_sink" {
  source = "../../"
  name   = "test-folder-sink-gcs"
  folder = "${data.google_active_folder.folder.name}"
  filter = "severity > WARNING"

  storage = {
    name    = "${var.gcs_bucket_prefix}-folder-sink-${var.gcs_bucket_suffix}"
    project = "${var.project_name}"
  }
}

# Example of a project-level sink to a Cloud Storage bucket
module "project_sink" {
  source  = "../../"
  name    = "test-project-sink-gcs"
  project = "${var.project_name}"

  storage = {
    name    = "${var.gcs_bucket_prefix}-project-sink-${var.gcs_bucket_suffix}"
    project = "${var.project_name}"
  }
}
