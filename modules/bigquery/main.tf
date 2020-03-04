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

#-----------------#
# Local variables #
#-----------------#

locals {
  destination_uri = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${module.dataset.bigquery_dataset.dataset_id}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = var.project_id
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

#------------------#
# Bigquery dataset #
#------------------#
module "dataset" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 4.0"

  dataset_id                  = var.dataset_name
  project_id                  = google_project_service.enable_destination_api.project
  location                    = var.location
  access                      = var.access
  description                 = var.description
  default_table_expiration_ms = var.default_table_expiration_ms

  # labels                      = var.labels
  # delete_contents_on_destroy  = var.delete_contents_on_destroy
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "bigquery_sink_member" {
  project = module.dataset.project
  role    = "roles/bigquery.dataEditor"
  member  = var.log_sink_writer_identity
}
