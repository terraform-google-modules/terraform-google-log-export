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

output "console_link" {
  description = "The console link to the destination storage bucket"
  value       = "https://console.cloud.google.com/cloudpubsub/topics/${local.topic_name}?project=${var.project_id}"
}

output "project" {
  description = "The project in which the topic was created."
  value       = google_pubsub_topic.topic.project
}

output "resource_name" {
  description = "The resource name for the destination topic"
  value       = local.topic_name
}

output "resource_id" {
  description = "The resource id for the destination topic"
  value       = google_pubsub_topic.topic.id
}

output "destination_uri" {
  description = "The destination URI for the topic."
  value       = local.destination_uri
}

output "pubsub_subscriber" {
  description = "Pub/Sub subscriber email (if any)"
  value       = local.pubsub_subscriber
}

output "pubsub_subscription" {
  description = "Pub/Sub subscription id (if any)"
  value       = local.pubsub_subscription
}

output "pubsub_push_subscription" {
  description = "Pub/Sub push subscription id (if any)"
  value       = local.pubsub_push_subscription
}
