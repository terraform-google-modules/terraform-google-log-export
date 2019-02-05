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

output "sink" {
  description = "Log sink data map"
  value       = "${local.sink_output}"
}

output "destination" {
  description = "Destination data map"
  value       = "${local.destination_output}"
}

output "pubsub_subscriber" {
  description = "Pub/Sub subscriber email (if any)"
  value       = "${local.pubsub_subscriber}"
}

output "pubsub_subscription" {
  description = "Pub/Sub subscription id (if any)"
  value       = "${local.pubsub_subscription}"
}
