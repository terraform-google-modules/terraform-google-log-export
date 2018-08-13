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

resource "google_folder" "folder" {
  display_name = "${var.folder_name}"
  parent       = "organizations/${var.org_id}"
}

resource "google_project" "project" {
  name            = "${var.project_name}"
  project_id      = "${var.project_name}"
  folder_id       = "${google_folder.folder.name}"
  billing_account = "${var.billing_id}"

  depends_on = [
    "google_folder.folder",
  ]
}
