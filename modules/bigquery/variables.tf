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

variable "bigquery_dataset_names" {
  description = "The name of the bigquery datasets to be created and used for log entries matching the filter."
  type        = "list"
}

variable "bigquery_dataset_location" {
  description = "The location of the storage bucket."
  default     = "US"
}

variable "bigquery_delete_contents_on_destroy" {
  description = "Delete dataset contents on destroy"
  default     = "true"
}

variable "destination_project_id" {
  description = "The ID of the project in which the bigquery dataset will be created."
}

variable "location" {
  description = "The location of the storage bucket."
  default     = "US"
}

variable "delete_contents_on_destroy" {
  description = "(Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  default     = "true"
}