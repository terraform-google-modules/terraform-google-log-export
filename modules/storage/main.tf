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
  destination_uri = "storage.googleapis.com/${module.bucket.bucket.name}"
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
module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.4"

  name               = var.storage_bucket_name
  project_id         = google_project_service.enable_destination_api.project
  storage_class      = var.storage_class
  location           = var.location
  force_destroy      = var.force_destroy
  bucket_policy_only = var.bucket_policy_only
  iam_members = var.iam_members + [{
    role   = "roles/storage.objectCreator"
    member = var.log_sink_writer_identity
  }]
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_storage_bucket_iam_member" "storage_sink_member" {
  bucket = local.storage_bucket_name
  role   = "roles/storage.objectCreator"
  member = var.log_sink_writer_identity
}
