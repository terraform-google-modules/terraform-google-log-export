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

variable "storage_bucket_names" {
  description = "The name of the storage buckets to be created and used for log entries matching the filter."
  type        = "list"
}

variable "storage_bucket_location" {
  description = "The location of the storage bucket."
  default     = "US"
}

variable "storage_bucket_class" {
  description = "The storage class of the storage bucket."
  default     = "MULTI_REGIONAL"
}

variable "storage_bucket_versioning_enabled" {
  description = "If true, enables bucket versioning"
  default     = "false"
}

variable "destination_project_id" {
  description = "The ID of the project in which the pubsub topics will be created."
}

variable "location" {
  description = "The location of the storage bucket."
  default     = "US"
}

variable "storage_class" {
  description = "The storage class of the storage bucket."
  default     = "MULTI_REGIONAL"
}
