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

variable "bucket_description" {
  description = "Log bucket description."
  type        = string
  default     = null
}

variable "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module)."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the storage bucket will be created."
  type        = string
}

variable "bucket_id" {
  description = "The name of the log bucket to be created or used for log entries matching the filter."
  type        = string
}

variable "location" {
  description = "The location of the storage bucket."
  type        = string
  default     = "global"
}

variable "retention_days" {
  description = "Log retention in days."
  type        = number
  default     = 30
}