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
variable "enable_splunk" {
  description = "Enable Splunk compatibility. If 'true', a subscription is created along with a service account that is granted needed additional roles to the topic."
  default     = "false"
}

variable "destination_project_id" {
  description = "The ID of the project in which the pubsub topics will be created."
}

variable "pubsub_topic_names" {
  description = "The names of the pubsub topics to be created and used for log entries matching the filter."
  type        = "list"
}

variable "pubsub_topic_labels" {
  description = "A set of key/value label pairs to assign to the pubsub topics."
  type        = "map"
  default     = {}
}
