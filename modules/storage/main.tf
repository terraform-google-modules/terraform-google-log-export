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

locals {
  project_id           = "${var.destination_project_id != "" ? var.destination_project_id : var.parent_resource_type == "project" ? var.parent_resource_id : ""}"
  storage_bucket_names = "${google_storage_bucket.bucket.*.name}"
  destination_uris     = "${formatlist("storage.googleapis.com/%s", local.storage_bucket_names)}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = "${local.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}

#----------------#
# Storage bucket #
#----------------#
resource "google_storage_bucket" "bucket" {
  count         = "${length(var.storage_bucket_names)}"
  name          = "${var.storage_bucket_names[count.index]}"
  project       = "${google_project_service.enable_destination_api.project}"
  storage_class = "${var.storage_bucket_class}"
  location      = "${var.storage_bucket_location}"
  force_destroy = true
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_storage_bucket_iam_member" "storage_sink_member" {
  count  = "${length(var.storage_bucket_names)}"
  bucket = "${local.storage_bucket_names[count.index]}"
  role   = "roles/storage.objectCreator"
  member = "${module.sink.sink_writer_identities[count.index]}"
}
