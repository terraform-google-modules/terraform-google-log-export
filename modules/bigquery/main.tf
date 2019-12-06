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
  dataset_name = element(
    concat(google_bigquery_dataset.dataset.*.dataset_id, [""]),
    0,
  )
  destination_uri = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${local.dataset_name}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = var.project_id
  service            = "bigquery-json.googleapis.com"
  disable_on_destroy = false
}

#------------------#
# Bigquery dataset #
#------------------#
resource "google_bigquery_dataset" "dataset" {
  count                       = var.default_table_expiration_ms != "0" ? 1 : 0
  dataset_id                  = var.dataset_name
  project                     = google_project_service.enable_destination_api.project
  location                    = var.location
  description                 = var.description
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  default_table_expiration_ms = var.default_table_expiration_ms
  labels                      = var.labels
}
   
#------------------------------#
# Bigquery dataset - no expiry #
#------------------------------#
resource "google_bigquery_dataset" "dataset" {
  count                       = var.default_table_expiration_ms == "0" ? 1 : 0
  dataset_id                  = var.dataset_name
  project                     = google_project_service.enable_destination_api.project
  location                    = var.location
  description                 = var.description
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  labels                      = var.labels
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "bigquery_sink_member" {
  project = google_bigquery_dataset.dataset.project
  role    = "roles/bigquery.dataEditor"
  member  = var.log_sink_writer_identity
}
