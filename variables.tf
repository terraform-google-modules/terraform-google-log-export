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

variable "destination_uri" {
  description = "The self_link URI of the destination resource (This is available as an output coming from one of the destination submodules)"
}

variable "filter" {
  description = "The filter to apply when exporting logs. Only log entries that match the filter are exported. Default is '' which exports all logs."
  default     = ""
}

variable "include_children" {
  description = "Only valid if 'organization' or 'folder' is chosen as var.parent_resource.type. Determines whether or not to include children organizations/folders in the sink export. If true, logs associated with child projects are also exported; otherwise only logs relating to the provided organization/folder are included."
  default     = "false"
}

variable "log_sink_name" {
  description = "The name of the log sink to be created."
}

variable "unique_writer_identity" {
  description = "Whether or not to create a unique identity associated with this sink. If false (the default), then the writer_identity used is serviceAccount:cloud-logs@system.gserviceaccount.com. If true, then a unique service account is created and used for the logging sink."
  default     = "false"
}

variable "parent" {
  description = "The GCP parent string, format: 'resource_type/resource_id'. `resource_type` - must be one of the following: 'project', 'folder', 'billing_account', or 'organization'; `resource_id` - the ID of the GCP resource in which you create the log sink. If var.parent_resource_type is set to 'project', then this is the Project ID (and etc)."
  type        = string
}
