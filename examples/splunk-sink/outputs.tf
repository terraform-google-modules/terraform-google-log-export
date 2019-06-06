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

output "pubsub_topic_project" {
  description = "Pub/Sub topic project id"
  value       = "${module.log_export.destination_project}"
}

output "pubsub_topic_names" {
  description = "Pub/Sub topic names"
  value       = "${module.log_export.destination_resource_id}"
}

output "pubsub_subscription_names" {
  description = "Pub/Sub topic subscription names"
  value       = "${module.log_export.pubsub_subscriptions}"
}

output "pubsub_subscribers" {
  description = "Pub/Sub topic subscribers emails"
  value       = "${module.log_export.pubsub_subscribers}"
}
