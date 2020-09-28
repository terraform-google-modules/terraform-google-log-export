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
  description = "The organization id for the associated services"
  type        = string
}

variable "credentials_path" {
  description = "Path to a service account credentials file with rights to run Terraform. Service Account must have the roles listed in the Requirements section of the README file."
  type        = string
}

variable "region" {
  description = "Region for BigQuery resources."
  type        = string
}

variable "source_name" {
  description = "The Security Command Center Source name for the \"BQ Log Alerts\" Source if the source had been created before. The format is `organizations/<ORG_ID>/sources/<SOURCE_ID>`"
  type        = string
  default     = ""
}

variable "logging_project" {
  description = "The project to deploy the solution"
  type        = string
}

variable "dry_run" {
  description = "Enable dry_run execution of the Cloud Function. If is true it will just print the object the would be converted as a finding"
  type        = bool
  default     = false
}
