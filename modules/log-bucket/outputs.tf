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

output "project" {
  description = "The project in which the logging bucket was created."
  value       = google_logging_project_bucket_config.bucket.project
}

output "resource_name" {
  description = "The resource name for the destination logging bucket"
  value       = local.log_bucket_name
}

output "resource_id" {
  description = "The resource id for the destination logging bucket"
  value       = google_logging_project_bucket_config.bucket.id
}

output "self_link" {
  description = "The self_link URI for the destination logging bucket"
  value       = google_logging_project_bucket_config.bucket.id
}

output "destination_uri" {
  description = "The destination URI for the logging bucket."
  value       = local.destination_uri
}

