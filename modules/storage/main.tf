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

locals {
  storage_bucket_name = element(concat(google_storage_bucket.bucket.*.name, [""]), 0)
  destination_uri     = "storage.googleapis.com/${local.storage_bucket_name}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = var.project_id
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}

#----------------#
# Storage bucket #
#----------------#
resource "google_storage_bucket" "bucket" {
  name                        = var.storage_bucket_name
  project                     = google_project_service.enable_destination_api.project
  storage_class               = var.storage_class
  location                    = var.location
  uniform_bucket_level_access = var.bucket_policy_only
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_storage_bucket_iam_member" "storage_sink_member" {
  bucket = local.storage_bucket_name
  role   = "roles/storage.objectCreator"
  member = var.log_sink_writer_identity
}
