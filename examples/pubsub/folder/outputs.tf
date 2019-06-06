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

output "log_export_map" {
  description = "Outputs from the log export module"

  value = {
    filters           = "${module.log_export.sink_filters}"
    resource_ids      = "${module.log_export.sink_resource_ids}"
    resource_names    = "${module.log_export.sink_resource_names}"
    parent_id         = "${module.log_export.sink_parent_id}"
    writer_identities = "${module.log_export.sink_writer_identities}"
  }
}

output "destination_map" {
  description = "Outputs from the destination module"

  value = {
    project              = "${module.log_export.destination_project}"
    console_links        = "${module.log_export.destination_console_links}"
    resource_names       = "${module.log_export.destination_resource_names}"
    resource_ids         = "${module.log_export.destination_resource_ids}"
    destination_uris     = "${module.log_export.destination_uris}"
    pubsub_subscribers   = "${module.log_export.pubsub_subscribers}"
    pubsub_subscriptions = "${module.log_export.pubsub_subscriptions}"
  }
}
