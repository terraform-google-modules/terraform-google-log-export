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
  description = "The ID of the project in which the log export will be created."
  type        = string
}

variable "parent_resource_id" {
  description = "The ID of the project in which pubsub topic destination will be created."
  type        = string
}

variable "push_endpoint" {
  description = "The URL locating the endpoint to which messages should be pushed."
  type        = string
}

variable "key_output_path" {
  description = "The path to a directory where the JSON private key of the new Datadog service account will be created."
  type        = string
  default     = "../datadog-sink/datadog-sa-key.json"
}
