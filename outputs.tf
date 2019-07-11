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

output "filter" {
  description = "The filter to be applied when exporting logs."
  value       = var.filter
}

output "log_sink_resource_id" {
  description = "The resource ID of the log sink that was created."
  value       = local.log_sink_resource_id
}

output "log_sink_resource_name" {
  description = "The resource name of the log sink that was created."
  value       = local.log_sink_resource_name
}

output "parent_resource_id" {
  description = "The ID of the GCP resource in which you create the log sink."
  value       = local.log_sink_parent_id
}

output "writer_identity" {
  description = "The service account that logging uses to write log entries to the destination."
  value       = local.log_sink_writer_identity
}

