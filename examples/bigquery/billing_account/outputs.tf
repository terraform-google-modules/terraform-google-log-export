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

output "log_export_map" {
  description = "Outputs from the log export module"

  value = {
    filter                 = module.log_export.filter
    log_sink_resource_id   = module.log_export.log_sink_resource_id
    log_sink_resource_name = module.log_export.log_sink_resource_name
    parent_resource_id     = module.log_export.parent_resource_id
    writer_identity        = module.log_export.writer_identity
  }
}

output "destination_map" {
  description = "Outputs from the destination module"

  value = {
    console_link    = module.destination.console_link
    project         = module.destination.project
    resource_name   = module.destination.resource_name
    resource_id     = module.destination.resource_id
    self_link       = module.destination.self_link
    destination_uri = module.destination.destination_uri
  }
}
