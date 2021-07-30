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

variable "create_subscriber" {
  description = "Whether to create a subscription to the topic that was created and used for log entries matching the filter. If 'true', a pull subscription is created along with a service account that is granted roles/pubsub.subscriber and roles/pubsub.viewer to the topic."
  type        = bool
  default     = false
}

variable "subscriber_id" {
  description = "The ID to give the pubsub pull subscriber service account (optional)."
  type        = string
  default     = ""
}

variable "subscription_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the pubsub subscription."
}

variable "create_push_subscriber" {
  description = "Whether to add a push configuration to the subcription. If 'true', a push subscription is created along with a service account that is granted roles/pubsub.subscriber and roles/pubsub.viewer to the topic."
  type        = bool
  default     = false
}

variable "push_endpoint" {
  description = "The URL locating the endpoint to which messages should be pushed."
  type        = string
  default     = ""
}

variable "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module)."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the pubsub topic will be created."
  type        = string
}

variable "topic_name" {
  description = "The name of the pubsub topic to be created and used for log entries matching the filter."
  type        = string
}

variable "topic_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the pubsub topic."
}

variable "kms_key_name" {
  description = "ID of a Cloud KMS CryptoKey to be used to protect access to messages published on this topic. Your project's PubSub service account requires access to this encryption key."
  type        = string
  default     = null
}
