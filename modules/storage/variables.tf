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

variable "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module)."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the storage bucket will be created."
  type        = string
}

variable "storage_bucket_name" {
  description = "The name of the storage bucket to be created and used for log entries matching the filter."
  type        = string
}

variable "location" {
  description = "The location of the storage bucket."
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "The storage class of the storage bucket."
  type        = string
  default     = "MULTI_REGIONAL"
}

variable "bucket_policy_only" {
  description = "Enables Bucket Policy Only access to a bucket."
  type        = bool
  default     = false
}

variable "expiration_days" {
  description = "Object expiration time. If unset logs will never be deleted."
  type        = number
  default     = null
}

variable "retention_policy" {
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type = object({
    is_locked        = bool
    retention_period = number
  })
  default = null
}