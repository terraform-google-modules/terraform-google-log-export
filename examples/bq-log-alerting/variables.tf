/**
 * Copyright 2020 Google LLC
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
  description = "The organization ID for the associated services"
  type        = string
}

variable "function_region" {
  description = "Region for the Cloud function resources. See https://cloud.google.com/functions/docs/locations for valid values."
  type        = string
}

variable "bigquery_location" {
  description = "Location for BigQuery resources. See https://cloud.google.com/bigquery/docs/locations for valid values."
  type        = string
  default     = "US"
}

variable "source_name" {
  description = "The Security Command Center Source name for the \"BQ Log Alerts\" Source if the source had been created before. The format is `organizations/<ORG_ID>/sources/<SOURCE_ID>`"
  type        = string
  default     = ""
}

variable "logging_project" {
  description = "The project to deploy the submodule"
  type        = string
}
