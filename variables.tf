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

variable "org_id" {
  description = "The organization id (required if org-level sink)"
  default     = ""
}

variable "billing_id" {
  description = "The billing id (required if billing-level sink)"
  default     = ""
}

variable "folder" {
  description = "The folder name (required if folder-level sink)"
  default     = ""
}

variable "project" {
  description = "The project name (required if project-level sink)"
  default     = ""
}

variable "name" {
  description = "The logsink name"
}

variable "filter" {
  description = "The log filter"
  default     = ""               # no filter, export all logs
}

variable "include_children" {
  description = "Include children folder or projects in the sink"
  default     = true
}

variable "unique_writer_identity" {
  description = "Whether or not to create a unique identity associated with this sink. If false (default), then the writer_identity used is serviceAccount:cloud-logs@system.gserviceaccount.com."
  default     = false
}

variable "bigquery" {
  type    = "map"
  default = {}
}

variable "storage" {
  type    = "map"
  default = {}
}

variable "pubsub" {
  type    = "map"
  default = {}
}
