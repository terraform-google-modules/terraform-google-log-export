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
  description = "The console link to the destination log buckets"
  value       = "https://console.cloud.google.com/logs/storage?project=${var.project_id}"
}

output "project" {
  description = "The project in which the log bucket was created."
  value       = google_logging_project_bucket_config.bucket.project
}

output "resource_name" {
  description = "The resource name for the destination log bucket"
  value       = google_logging_project_bucket_config.bucket.bucket_id
}

output "destination_uri" {
  description = "The destination URI for the log bucket."
  value       = local.destination_uri
}
