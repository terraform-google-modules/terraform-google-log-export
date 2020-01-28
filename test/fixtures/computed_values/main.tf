/**
 * Copyright 2019 Google LLC
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

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "google_project" "computed" {
  name            = "log-exports-computed-${random_string.suffix.result}"
  folder_id       = var.parent_resource_folder
  project_id      = "log-exports-computed-${random_string.suffix.result}"
  billing_account = var.parent_resource_billing_account
}

module "log_export" {
  source             = "../../../examples/storage/project"
  parent_resource_id = google_project.computed.project_id
  project_id         = google_project.computed.project_id
}
