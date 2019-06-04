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
  project_id           = "${var.destination_project_id != "" ? var.destination_project_id : var.parent_resource_type == "project" ? var.parent_resource_id : ""}"
  destination_uris     = "${formatlist("pubsub.googleapis.com/projects/${local.project_id}/topics/%s", local.pubsub_topic_names)}"
  pubsub_topic_names   = "${google_pubsub_topic.topic.*.name}"
  pubsub_subscribers   = "${var.enable_splunk ? join(",", google_service_account.pubsub_subscriber.*.email) : local.empty_list}"
  pubsub_subscriptions = "${var.enable_splunk ? join(",", google_pubsub_subscription.pubsub_subscription.*.id) : local.empty_list}"
  empty_list           = "${join(",", data.template_file.empty_list.*.rendered)}"
}

data "template_file" "empty_list" {
  count    = "${length(var.pubsub_topic_names)}"
  template = ""
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project            = "${local.project_id}"
  service            = "pubsub.googleapis.com"
  disable_on_destroy = false
}

#--------------#
# Pubsub topic #
#--------------#
resource "google_pubsub_topic" "topic" {
  count   = "${length(var.pubsub_topic_names)}"
  name    = "${var.pubsub_topic_names[count.index]}"
  project = "${google_project_service.enable_destination_api.project}"
  labels  = "${var.pubsub_topic_labels}"
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_pubsub_topic_iam_member" "pubsub_sink_member" {
  count   = "${length(var.pubsub_topic_names)}"
  project = "${local.project_id}"
  topic   = "${local.pubsub_topic_names[count.index]}"
  role    = "roles/pubsub.publisher"
  member  = "${module.sink.sink_writer_identities[count.index]}"
}

#-----------------------------------------------#
# Pub/Sub topic subscription (for integrations) #
#-----------------------------------------------#
resource "google_service_account" "pubsub_subscriber" {
  count        = "${var.enable_splunk ? length(local.pubsub_topic_names) : 0}"
  account_id   = "${local.pubsub_topic_names[count.index]}-subscriber"
  display_name = "${local.pubsub_topic_names[count.index]} Topic Subscriber"
  project      = "${local.project_id}"
}

resource "google_pubsub_topic_iam_member" "pubsub_subscriber_role" {
  count   = "${var.enable_splunk ? length(local.pubsub_topic_names) : 0}"
  role    = "roles/pubsub.subscriber"
  project = "${local.project_id}"
  topic   = "${local.pubsub_topic_names[count.index]}"
  member  = "serviceAccount:${google_service_account.pubsub_subscriber.*.email[count.index]}"
}

resource "google_pubsub_topic_iam_member" "pubsub_viewer_role" {
  count   = "${var.enable_splunk ? length(local.pubsub_topic_names) : 0}"
  role    = "roles/pubsub.viewer"
  project = "${local.project_id}"
  topic   = "${local.pubsub_topic_names[count.index]}"
  member  = "serviceAccount:${google_service_account.pubsub_subscriber.*.email[count.index]}"
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  count   = "${var.enable_splunk ? length(local.pubsub_topic_names) : 0}"
  name    = "${local.pubsub_topic_names[count.index]}-subscription"
  project = "${local.project_id}"
  topic   = "${local.pubsub_topic_names[count.index]}"
}
