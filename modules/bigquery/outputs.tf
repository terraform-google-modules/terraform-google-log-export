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
  description = "The console link to the destination bigquery dataset"
  value       = "https://bigquery.cloud.google.com/dataset/${var.project_id}:${local.dataset_name}"
}

output "project" {
  description = "The project in which the bigquery dataset was created."
  value       = google_bigquery_dataset.dataset.project
}

output "resource_name" {
  description = "The resource name for the destination bigquery dataset"
  value       = local.dataset_name
}

output "resource_id" {
  description = "The resource id for the destination bigquery dataset"
  value       = google_bigquery_dataset.dataset.id
}

output "self_link" {
  description = "The self_link URI for the destination bigquery dataset"
  value       = google_bigquery_dataset.dataset.self_link
}

output "destination_uri" {
  description = "The destination URI for the bigquery dataset."
  value       = local.destination_uri
}

