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

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "log_export" {
  source                 = "../../../"
  destination_uri        = module.destination.destination_uri
  filter                 = "resource.type = gce_instance"
  log_sink_name          = "bigquery_folder_${random_string.suffix.result}"
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = "folder"
  unique_writer_identity = true
}

module "destination" {
  source                   = "../../..//modules/bigquery"
  project_id               = var.project_id
  dataset_name             = "bq_folder_${random_string.suffix.result}"
  log_sink_writer_identity = module.log_export.writer_identity
}
