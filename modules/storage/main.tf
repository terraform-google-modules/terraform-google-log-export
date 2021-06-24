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
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.uniform_bucket_level_access
  labels                      = var.storage_bucket_labels

  versioning {
    enabled = var.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.expiration_days == null ? [] : [var.expiration_days]
    content {
      action {
        type = "Delete"
      }
      condition {
        age        = var.expiration_days
        with_state = "ANY"
      }
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]
    content {
      is_locked        = var.retention_policy.is_locked
      retention_period = var.retention_policy.retention_period_days * 24 * 60 * 60 // days to seconds
    }
  }
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_storage_bucket_iam_member" "storage_sink_member" {
  bucket = local.storage_bucket_name
  role   = "roles/storage.objectCreator"
  member = var.log_sink_writer_identity
}
