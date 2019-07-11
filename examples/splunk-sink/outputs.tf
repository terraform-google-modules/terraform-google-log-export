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

output "pubsub_topic_name" {
  description = "Pub/Sub topic name"
  value       = module.destination.resource_id
}

output "pubsub_topic_project" {
  description = "Pub/Sub topic project id"
  value       = module.destination.project
}

output "pubsub_subscription_name" {
  description = "Pub/Sub topic subscription name"
  value       = module.destination.pubsub_subscription
}

output "pubsub_subscriber" {
  description = "Pub/Sub topic subscriber email"
  value       = module.destination.pubsub_subscriber
}

