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
  # Booleans for destination type and sink level
  is_pubsub        = "${length(keys(var.pubsub)) > 0 ? 1 : 0}"
  is_bigquery      = "${length(keys(var.bigquery)) > 0 ? 1 : 0}"
  is_storage       = "${length(keys(var.storage)) > 0 ? 1 : 0}"
  is_project_level = "${var.project != "" ? 1 : 0}"
  is_folder_level  = "${var.folder != "" ? 1 : 0}"
  is_org_level     = "${var.org_id != "" ? 1 : 0}"
  is_billing_level = "${var.billing_id != "" ? 1 : 0}"

  # Sink destination data
  destination_type         = "${local.is_pubsub ? "pubsub" : local.is_bigquery ? "bigquery" : local.is_storage ? "storage" : ""}"
  destination              = "${local.destinations_map[local.destination_type]}"
  destination_project      = "${local.destination["project"]}"
  destination_name         = "${local.destination["name"]}"
  destination_console_link = "${local.web_map[local.destination_type]}"
  destination_uri          = "${local.uri_map[local.destination_type]}"
  destination_api          = "${local.api_map[local.destination_type]}"

  # Additional options for specific destinations
  pubsub_create_subscriber = "${lookup(local.destination, "create_subscriber", false)}"
  pubsub_subscriber        = "${element(concat(google_service_account.pubsub_subscriber.*.email, list("")), 0)}"
  pubsub_subscription      = "${element(concat(google_pubsub_subscription.pubsub_subscription.*.id, list("")), 0)}"

  # Role assigned to sink writer and sink level
  role  = "${local.role_map[local.destination_type]}"
  level = "${local.is_project_level ? "project" : local.is_folder_level ? "folder" : local.is_org_level ? "organization" : local.is_billing_level ? "billing" : ""}"

  # Map of sink destination type to hash config
  destinations_map = {
    pubsub   = "${var.pubsub}"
    storage  = "${var.storage}"
    bigquery = "${var.bigquery}"
  }

  # GCP roles to grant based on the sink destination type
  role_map = {
    pubsub   = "roles/pubsub.publisher"
    bigquery = "roles/bigquery.dataEditor"
    storage  = "roles/storage.objectCreator"
  }

  # Destination URLs based on the sink destination type
  uri_map = {
    pubsub   = "pubsub.googleapis.com/projects/${local.destination_project}/topics/${local.destination_name}"
    bigquery = "bigquery.googleapis.com/projects/${local.destination_project}/datasets/${local.destination_name}"
    storage  = "storage.googleapis.com/${local.destination_name}"
  }

  # API map
  api_map = {
    pubsub   = "pubsub.googleapis.com"
    bigquery = "bigquery-json.googleapis.com"
    storage  = "storage-component.googleapis.com"
  }

  # Destination console URLs based on the sink destination type
  web_map = {
    pubsub   = "https://console.cloud.google.com/cloudpubsub/topics/${local.destination_name}?project=${local.destination_project}"
    bigquery = "https://bigquery.cloud.google.com/dataset/${local.destination_project}:${local.destination_name}"
    storage  = "https://console.cloud.google.com/storage/browser/${local.destination_name}?project=${local.destination_project}"
  }

  # Sink output data
  sink_output = {
    resource_name = "${local.is_project_level ? var.project : local.is_folder_level ? var.folder : local.is_org_level ? var.org_id : ""}"
    resource      = "${local.is_project_level ? element(concat(google_logging_project_sink.sink.*.id, list("")), 0) : local.is_folder_level ? element(concat(google_logging_folder_sink.sink.*.id, list("")), 0) : local.is_org_level ? element(concat(google_logging_organization_sink.sink.*.id, list("")), 0) : local.is_billing_level ? element(concat(google_logging_billing_account_sink.sink.*.id, list("")), 0) : ""}"
    writer        = "${local.is_project_level ? element(concat(google_logging_project_sink.sink.*.writer_identity, list("")), 0) : local.is_folder_level ? element(concat(google_logging_folder_sink.sink.*.writer_identity, list("")), 0) : local.is_org_level ? element(concat(google_logging_organization_sink.sink.*.writer_identity, list("")), 0) : local.is_billing_level ? element(concat(google_logging_billing_account_sink.sink.*.writer_identity, list("")), 0) : ""}"
    console_link  = "${local.is_project_level ? "https://console.cloud.google.com/logs/exports?project=${var.project}" : ""}"
    name          = "${var.name}"
    filter        = "${var.filter}"
  }

  # Sink destination output data
  destination_output = {
    resource     = "${local.is_pubsub ? element(concat(google_pubsub_topic.topic.*.id, list("")), 0) : local.is_bigquery ? element(concat(google_bigquery_dataset.dataset.*.id, list("")), 0) : local.is_storage ? element(concat(google_storage_bucket.bucket.*.id, list("")), 0) : ""}"
    self_link    = "${local.destination_uri}"
    console_link = "${local.destination_console_link}"
    type         = "${local.destination_type}"
    name         = "${local.destination_name}"
    project      = "${local.is_pubsub ? element(concat(google_pubsub_topic.topic.*.project, list("")), 0) : local.is_bigquery ? element(concat(google_bigquery_dataset.dataset.*.project, list("")), 0) : local.is_storage ? element(concat(google_storage_bucket.bucket.*.project, list("")), 0) : ""}"
  }
}

#---------------------#
# Logsink destination #
#---------------------#
resource "google_project_service" "enable_destination_api" {
  project            = "${local.destination_project}"
  service            = "${local.destination_api}"
  disable_on_destroy = false
}

# Pub/Sub topic
resource "google_pubsub_topic" "topic" {
  count   = "${local.destination_type == "pubsub" ? 1 : 0}"
  name    = "${local.destination_name}"
  project = "${local.destination_project}"

  depends_on = [
    "google_project_service.enable_destination_api",
  ]
}

# BigQuery dataset
resource "google_bigquery_dataset" "dataset" {
  count      = "${local.destination_type == "bigquery" ? 1 : 0}"
  dataset_id = "${local.destination_name}"
  project    = "${local.destination_project}"

  # Delete all tables in dataset on destroy.
  # This is required because a dataset cannot be deleted if it contains any data.
  provisioner "local-exec" {
    when    = "destroy"
    command = "sh ${path.module}/scripts/delete-bq-tables.sh ${local.destination_project} ${local.destination_name}"
  }

  depends_on = [
    "google_project_service.enable_destination_api",
  ]
}

# Storage bucket
resource "google_storage_bucket" "bucket" {
  count         = "${local.destination_type == "storage" ? 1 : 0}"
  name          = "${local.destination_name}"
  project       = "${local.destination_project}"
  storage_class = "MULTI_REGIONAL"
  location      = "US"
  force_destroy = true

  depends_on = [
    "google_project_service.enable_destination_api",
  ]
}

#---------#
# Logsink #
#---------#

# Project-level
resource "google_logging_project_sink" "sink" {
  count                  = "${local.is_project_level ? 1 : 0}"
  name                   = "${var.name}"
  project                = "${var.project}"
  filter                 = "${var.filter}"
  destination            = "${local.destination_uri}"
  unique_writer_identity = "${var.unique_writer_identity}"

  depends_on = [
    "google_storage_bucket.bucket",
    "google_pubsub_topic.topic",
    "google_bigquery_dataset.dataset",
  ]
}

# Folder-level
resource "google_logging_folder_sink" "sink" {
  count            = "${local.is_folder_level ? 1 : 0}"
  name             = "${var.name}"
  folder           = "${var.folder}"
  filter           = "${var.filter}"
  include_children = "${var.include_children}"
  destination      = "${local.destination_uri}"

  depends_on = [
    "google_storage_bucket.bucket",
    "google_pubsub_topic.topic",
    "google_bigquery_dataset.dataset",
  ]
}

# Org-level
resource "google_logging_organization_sink" "sink" {
  count            = "${local.is_org_level ? 1 : 0}"
  name             = "${var.name}"
  org_id           = "${var.org_id}"
  filter           = "${var.filter}"
  include_children = "${var.include_children}"
  destination      = "${local.destination_uri}"

  depends_on = [
    "google_storage_bucket.bucket",
    "google_pubsub_topic.topic",
    "google_bigquery_dataset.dataset",
  ]
}

#---------------------------------#
# Service account IAM memberships #
#---------------------------------#
resource "google_pubsub_topic_iam_member" "pubsub_sink_member" {
  count   = "${local.is_pubsub ? 1 : 0}"
  project = "${local.destination_project}"
  topic   = "${local.destination_name}"
  role    = "${local.role}"
  member  = "${local.sink_output["writer"]}"

  depends_on = [
    "google_pubsub_topic.topic",
  ]
}

resource "google_storage_bucket_iam_member" "storage_sink_member" {
  count  = "${local.is_storage ? 1 : 0}"
  bucket = "${local.destination_name}"
  role   = "${local.role}"
  member = "${local.sink_output["writer"]}"

  depends_on = [
    "google_storage_bucket.bucket",
  ]
}

resource "google_project_iam_member" "bigquery_sink_member" {
  count   = "${local.is_bigquery ? 1 : 0}"
  project = "${local.destination_project}"
  role    = "${local.role}"
  member  = "${local.sink_output["writer"]}"

  depends_on = [
    "google_bigquery_dataset.dataset",
  ]
}

#-----------------------------------------------#
# Pub/Sub topic subscription (for integrations) #
#-----------------------------------------------#
resource "google_service_account" "pubsub_subscriber" {
  count        = "${local.pubsub_create_subscriber ? 1 : 0}"
  account_id   = "${local.destination_name}-subscriber"
  display_name = "${local.destination_name} Topic Subscriber"
  project      = "${local.destination_project}"
}

resource "google_pubsub_topic_iam_member" "pubsub_subscriber_role" {
  count   = "${local.pubsub_create_subscriber ? 1 : 0}"
  role    = "roles/pubsub.subscriber"
  project = "${local.destination_project}"
  topic   = "${local.destination_name}"
  member  = "serviceAccount:${google_service_account.pubsub_subscriber.email}"

  depends_on = [
    "google_pubsub_topic.topic",
  ]
}

resource "google_pubsub_topic_iam_member" "pubsub_viewer_role" {
  count   = "${local.pubsub_create_subscriber ? 1 : 0}"
  role    = "roles/pubsub.viewer"
  project = "${local.destination_project}"
  topic   = "${local.destination_name}"
  member  = "serviceAccount:${google_service_account.pubsub_subscriber.email}"

  depends_on = [
    "google_pubsub_topic.topic",
  ]
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  count   = "${local.pubsub_create_subscriber ? 1 : 0}"
  name    = "${local.destination_name}-subscription"
  topic   = "${local.destination_name}"
  project = "${local.destination_project}"

  depends_on = [
    "google_pubsub_topic.topic",
  ]
}
