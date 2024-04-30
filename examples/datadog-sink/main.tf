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
  datadog_svc = element(google_service_account.datadog-viewer[*].email, 0)
  log_writ    = module.log_export.writer_identity
}

resource "google_service_account" "datadog-viewer" {
  account_id  = "${var.project_id}-datadog-viewer"
  description = "Service account for Datadog monitoring"
  project     = var.project_id
}

resource "google_service_account_key" "datadog-viewer-key" {
  service_account_id = google_service_account.datadog-viewer.name
}

resource "local_file" "key_export" {
  content_base64 = google_service_account_key.datadog-viewer-key.private_key
  filename       = var.key_output_path
}

resource "google_project_iam_member" "compute-viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.datadog-viewer.email}"
}

resource "google_project_iam_member" "cloudasset-viewer" {
  project = var.project_id
  role    = "roles/cloudasset.viewer"
  member  = "serviceAccount:${google_service_account.datadog-viewer.email}"
}

resource "google_project_iam_member" "monitoring-viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.datadog-viewer.email}"
}

module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 8.0"

  destination_uri        = module.destination.destination_uri
  log_sink_name          = "test-datadog-sink"
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/pubsub"
  version = "~> 8.0"

  project_id               = var.project_id
  topic_name               = "datadog-sink"
  log_sink_writer_identity = module.log_export.writer_identity
  create_subscriber        = false
  create_push_subscriber   = true
  push_endpoint            = var.push_endpoint
}
