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

variable "credentials_path" {
  description = "Path to a Service Account credentials file with permissions documented in the readme"
}

variable "org_id" {
  description = "The organization id (for org-level sink)"
}

variable "project_name" {
  description = "The project name (for project-level sink)"
}

variable "alt_project_name" {
  description = "The alternative project to create a destination in. Used to test creating destinations in other projects"
}

variable "folder_name" {
  description = "The folder name (for folder-level sink)"
}

variable "gcs_bucket_prefix" {
  description = "The GCS bucket name prefix"
}

variable "gcs_bucket_suffix" {
  description = "The GCS bucket name suffix"
}
