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

output "destination_project" {
  description = "The project in which the Pub/Sub topics were created"
  value       = "${element(google_pubsub_topic.topic.*.project, 0)}"
}

output "destination_resource_names" {
  description = "Map of log sink names to the Pub/Sub topics' names"
  value       = "${zipmap(var.sink_names, local.pubsub_topic_names)}"
}

output "destination_resource_ids" {
  description = "Map of log sink names to the Pub/Sub topics' resource ids"
  value       = "${zipmap(var.sink_names, google_pubsub_topic.topic.*.id)}"
}

output "destination_uris" {
  description = "Map of log sink names to the Pub/Sub topics' URIs"
  value       = "${zipmap(var.sink_names, local.destination_uris)}"
}

output "console_links" {
  description = "Map of log sink names to the Pub/Sub topics' console links"
  value       = "${zipmap(var.sink_names, formatlist("https://console.cloud.google.com/cloudpubsub/topics/%s?project=${local.project_id}", local.pubsub_topic_names))}"
}

output "pubsub_topic_labels" {
  description = "Pub/Sub labels applied to the topics"
  value       = "${var.pubsub_topic_labels}"
}

output "pubsub_subscribers" {
  description = "Map of Pub/Sub topics' names to their respective subscribers"
  value       = "${zipmap(var.pubsub_topic_names, split(",", local.pubsub_subscribers))}"
}

output "pubsub_subscriptions" {
  description = "Map of Pub/Sub topics' names to their respective subscriptions"
  value       = "${zipmap(var.pubsub_topic_names, split(",", local.pubsub_subscriptions))}"
}
