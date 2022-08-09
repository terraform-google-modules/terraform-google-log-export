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

variable "project_id" {
  description = "The ID of the project in which the log bucket will be created."
  type        = string
}

variable "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module)."
  type        = string
}

variable "name" {
  description = "The name of the log bucket to be created and used for log entries matching the filter."
  type        = string
}

variable "location" {
  description = "The location of the log bucket."
  type        = string
  default     = "global"
}

variable "retention_days" {
  description = "The number of days data should be retained for the log bucket."
  type        = number
  default     = 30
}

variable "grant_write_permission_on_bkt" {
  description = "(Optional) Indicates whether the module is responsible for granting write permission on the logbucket. This permission will be given by default, but if the user wants, this module can skip this step. This is the case when the sink route logs to a log bucket in the same Cloud project, no new service account will be created and this module will need to bypass granting permissions."
  type        = bool
  default     = true
}
