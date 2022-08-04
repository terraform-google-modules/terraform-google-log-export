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

output "log_bucket_project" {
  description = "The project where the log bucket is created."
  value       = module.destination.project
}

output "log_bucket_name" {
  description = "The name for the log bucket."
  value       = module.destination.resource_name
}

output "log_sink_folder_id" {
  description = "The folder id where the log sink is created."
  value       = module.log_export.parent_resource_id
}

output "log_sink_destination_uri" {
  description = "A fully qualified URI for the log sink."
  value       = module.destination.destination_uri
}

output "log_sink_writer_identity" {
  description = "Writer identity for the log sink that writes to the log bucket."
  value       = module.log_export.writer_identity
}
