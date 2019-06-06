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
  description = "The project in which the BigQuery dataset were created"
  value       = "${element(google_bigquery_dataset.dataset.*.project, 0)}"
}

output "destination_resource_names" {
  description = "Map of log sink names to the BigQuery dataset' names"
  value       = "${zipmap(var.sink_names, local.bigquery_dataset_names)}"
}

output "destination_resource_ids" {
  description = "Map of log sink names to the BigQuery dataset' resource ids"
  value       = "${zipmap(var.sink_names, google_bigquery_dataset.dataset.*.id)}"
}

output "destination_uris" {
  description = "Map of log sink names to the BigQuery dataset' URIs"
  value       = "${zipmap(var.sink_names, local.destination_uris)}"
}

output "destination_self_links" {
  description = "Map of log sink names to the Bigquery datasets' self links"
  value       = "${zipmap(var.sink_names, google_bigquery_dataset.dataset.*.self_link)}"
}

output "destination_console_links" {
  description = "Map of log sink names to the BigQuery dataset' console links"
  value       = "${zipmap(var.sink_names, formatlist("https://bigquery.cloud.google.com/dataset/${local.project_id}:%s", local.bigquery_dataset_names))}"
}
