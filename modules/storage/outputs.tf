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
  value       = "${element(google_storage_bucket.bucket.*.project, 0)}"
}

output "destination_resource_names" {
  description = "Map of log sink names to the Cloud Storage bucket resource names"
  value       = "${zipmap(var.sink_names, local.storage_bucket_names)}"
}

output "destination_uris" {
  description = "Map of log sink names to the Cloud Storage bucket URIs"
  value       = "${zipmap(var.sink_names, local.destination_uris)}"
}

output "console_links" {
  description = "Map of log sink names to the Pub/Sub bucket' console links"
  value       = "${zipmap(var.sink_names, formatlist("https://console.cloud.google.com/storage/browser/%s?project=${local.project_id}", local.storage_bucket_names))}"
}
