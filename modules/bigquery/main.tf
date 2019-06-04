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
  project_id             = "${var.destination_project_id != "" ? var.destination_project_id : var.parent_resource_type == "project" ? var.parent_resource_id : ""}"
  bigquery_dataset_names = "${google_bigquery_dataset.dataset.*.dataset_id}"
  destination_uris       = "${formatlist("bigquery.googleapis.com/projects/${local.project_id}/datasets/%s", local.bigquery_dataset_names)}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = "${local.project_id}"
  service            = "bigquery-json.googleapis.com"
  disable_on_destroy = false
}

#------------------#
# Bigquery dataset #
#------------------#
resource "google_bigquery_dataset" "dataset" {
  count                      = "${length(var.bigquery_dataset_names)}"
  project                    = "${google_project_service.enable_destination_api.project}"
  dataset_id                 = "${var.bigquery_dataset_names[count.index]}"
  location                   = "${var.bigquery_dataset_location}"
  delete_contents_on_destroy = "${var.bigquery_delete_contents_on_destroy}"
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "bigquery_sink_member" {
  count   = "${length(var.bigquery_dataset_names)}"
  project = "${element(google_bigquery_dataset.dataset.*.project, 0)}"
  role    = "roles/bigquery.dataEditor"
  member  = "${module.sink.sink_writer_identities[count.index]}"
}
