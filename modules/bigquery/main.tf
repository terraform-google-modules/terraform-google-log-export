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

#-----------------#
# Local variables #
#-----------------#

locals {
  dataset_name    = "${element(concat(google_bigquery_dataset.dataset.*.dataset_id, list("")), 0)}"
  destination_uri = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${local.dataset_name}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = "${var.project_id}"
  service            = "bigquery-json.googleapis.com"
  disable_on_destroy = false
}

#------------------#
# Bigquery dataset #
#------------------#
resource "google_bigquery_dataset" "dataset" {
  dataset_id = "${var.dataset_name}"
  project    = "${google_project_service.enable_destination_api.project}"
  location   = "${var.location}"
  # Delete all tables in dataset on destroy.
  # This is required because a dataset cannot be deleted if it contains any data.
  provisioner "local-exec" {
    when    = "destroy"
    command = "sh ${path.module}/scripts/delete-bq-tables.sh ${var.project_id} ${var.dataset_name}"
  }
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "bigquery_sink_member" {
  project = "${google_bigquery_dataset.dataset.project}"
  role    = "roles/bigquery.dataEditor"
  member  = "${var.log_sink_writer_identity}"
}
