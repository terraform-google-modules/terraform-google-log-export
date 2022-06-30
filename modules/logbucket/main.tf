/**
 * Copyright 2022 Google LLC
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
  log_bucket_id   = google_logging_project_bucket_config.bucket.id
  destination_uri = "logging.googleapis.com/${local.log_bucket_id}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = var.project_id
  service            = "logging.googleapis.com"
  disable_on_destroy = false
}

#------------#
# Log bucket #
#------------#

resource "google_logging_project_bucket_config" "bucket" {
  project        = google_project_service.enable_destination_api.project
  location       = var.location
  retention_days = var.retention_days
  bucket_id      = var.name
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "logbucket_sink_member" {
  project = google_logging_project_bucket_config.bucket.project
  role    = "roles/logging.bucketWriter"
  member  = var.log_sink_writer_identity
}
