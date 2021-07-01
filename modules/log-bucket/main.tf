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
  log_bucket_name = google_logging_project_bucket_config.bucket.name
  destination_uri = "logging.googleapis.com/${local.log_bucket_name}"
}

#----------------#
# Logging bucket #
#----------------#
resource "google_logging_project_bucket_config" "bucket" {
  project        = var.project_id
  location       = var.location
  bucket_id      = var.bucket_id
  description    = var.bucket_description
  retention_days = var.retention_days
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "storage_sink_member" {
  project = var.project_id
  role    = "roles/logging.bucketWriter"
  member  = var.log_sink_writer_identity
  condition {
    title       = format("%s project log bucket writer", var.project_id)
    description = format("Grants logging.bucketWriter role to service account %s used by log sink", var.log_sink_writer_identity)
    expression  = format("resource.name.endsWith(\"locations/%s/buckets/%s\")", var.location, var.bucket_id)
  }
}
