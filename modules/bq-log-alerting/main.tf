/**
 * Copyright 2020 Google LLC
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
  actual_source_name = var.source_name != "" ? var.source_name : google_scc_source.bq_log_alerts[0].name
}

#--------------------------#
# Service account creation #
#--------------------------#
resource "random_string" "service_account" {
  length  = 6
  upper   = "false"
  number  = "false"
  special = "false"
}

resource "google_service_account" "gcf_service_account" {
  project      = var.logging_project
  account_id   = "sa-bq-log-alerting-cf-${random_string.service_account.result}"
  display_name = "BigQuery Log Alerting Cloud Function Service Account"
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "gcf-big-query" {
  project = var.logging_project
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.gcf_service_account.email}"
}

resource "google_organization_iam_member" "gcf-security-findings" {
  org_id = var.org_id
  role   = "roles/securitycenter.findingsEditor"
  member = "serviceAccount:${google_service_account.gcf_service_account.email}"
}

#-----------------------------------------#
# Security Command Center Source creation #
#-----------------------------------------#
resource "google_scc_source" "bq_log_alerts" {
  count        = var.source_name == "" ? 1 : 0
  display_name = "BQ Log Alerts"
  organization = var.org_id
  description  = "Findings from BQ Alerting tool"
}

#------------------------#
# Bigquery views dataset #
#------------------------#
resource "google_bigquery_dataset" "views_dataset" {
  dataset_id    = "views"
  friendly_name = "Log Views"
  description   = "Log view dataset"
  location      = var.bigquery_location
  project       = var.logging_project

  labels = {
    env = "default"
  }
}

#-----------------------------#
# Scheduled function creation #
#-----------------------------#
module "bq-log-alerting" {
  source                         = "terraform-google-modules/scheduled-function/google"
  version                        = "1.5.1"
  project_id                     = var.logging_project
  job_name                       = "bq-alerts-event-trigger"
  job_description                = "publish to pubsub to trigger cloud function"
  job_schedule                   = var.job_schedule
  message_data                   = base64encode("{\"unit\":\"${var.time_window_unit}\",\"quantity\":\"${var.time_window_quantity}\"}")
  function_description           = "read from BQ view to generate alerts"
  function_entry_point           = "cronPubSub"
  function_source_directory      = "${path.module}/logging/cloud_function"
  function_name                  = "generate-alerts"
  function_runtime               = "nodejs10"
  function_service_account_email = google_service_account.gcf_service_account.email
  function_timeout_s             = var.function_timeout
  function_available_memory_mb   = var.function_memory
  topic_name                     = "bq-alerts-function-trigger"
  region                         = var.function_region

  function_environment_variables = {
    CSCC_SOURCE     = local.actual_source_name
    LOGGING_PROJECT = var.logging_project
    DRY_RUN         = var.dry_run
  }
}
