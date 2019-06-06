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

output "sink_parent_type" {
  description = "Sink parent type (organization, folder, project)"
  value       = "${var.parent_resource_type}"
}

output "sink_parent_id" {
  description = "Sink parent resource id"

  value = "${element(concat(
    google_logging_project_sink.sink.*.project,
    google_logging_folder_sink.sink.*.folder,
    google_logging_organization_sink.sink.*.org_id,
    google_logging_billing_account_sink.sink.*.billing_account), 0)}"
}

output "sink_writer_identities" {
  description = "Sink writer identities"

  value = "${concat(
    google_logging_project_sink.sink.*.writer_identity,
    google_logging_folder_sink.sink.*.writer_identity,
    google_logging_organization_sink.sink.*.writer_identity,
    google_logging_billing_account_sink.sink.*.writer_identity)}"
}

output "sink_resource_ids" {
  description = "Sink resource ids"

  value = "${concat(
    google_logging_project_sink.sink.*.id,
    google_logging_folder_sink.sink.*.id,
    google_logging_organization_sink.sink.*.id,
    google_logging_billing_account_sink.sink.*.id)}"
}

output "sink_resource_names" {
  description = "Sink resource names"

  value = "${concat(
    google_logging_project_sink.sink.*.name,
    google_logging_folder_sink.sink.*.name,
    google_logging_organization_sink.sink.*.name,
    google_logging_billing_account_sink.sink.*.name)}"
}
