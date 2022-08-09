/**
 * Copyright 2022 Google LLC
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

output "log_sink_project_id" {
  description = "The project id where the log sink is created."
  value       = module.log_export.parent_resource_id
}

output "log_sink_destination_uri" {
  description = "A fully qualified URI for the log sink."
  value       = module.destination.destination_uri
}

output "log_sink_resource_name" {
  description = "The resource name of the log sink that was created."
  value       = module.log_export.log_sink_resource_name
}

output "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination."
  value       = module.log_export.writer_identity
}


#-------------------------------------#
# Log Bucket and Sink in same project #
#-------------------------------------#
output "log_bkt_same_proj" {
  description = "The project where the log bucket is created for sink and logbucket in same project example."
  value       = module.dest_same_proj.project
}

output "log_bkt_name_same_proj" {
  description = "The name for the log bucket for sink and logbucket in same project example."
  value       = module.dest_same_proj.resource_name
}

output "log_sink_id_same_proj" {
  description = "The project id where the log sink is created for sink and logbucket in same project example."
  value       = module.log_export_same_proj.parent_resource_id
}

output "log_sink_dest_uri_same_proj" {
  description = "A fully qualified URI for the log sink for sink and logbucket in same project example."
  value       = module.dest_same_proj.destination_uri
}

output "log_sink_resource_name_same_proj" {
  description = "The resource name of the log sink that was created in same project example."
  value       = module.log_export_same_proj.log_sink_resource_name
}

output "log_sink_writer_identity_same_proj" {
  description = "The service account in same project example that logging uses to write log entries to the destination."
  value       = module.log_export_same_proj.writer_identity
}
