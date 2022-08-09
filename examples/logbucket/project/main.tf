/**
 * Copyright 2022 Google LLC
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
  log_sink_name          = "logbucket_other_project"
  parent_resource_id     = var.parent_resource_project
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "destination" {
  source                   = "../../..//modules/logbucket"
  project_id               = var.project_destination_logbkt_id
  name                     = "logbucket_from_other_project_${random_string.suffix.result}"
  location                 = "global"
  log_sink_writer_identity = module.log_export.writer_identity
}

#-------------------------------------#
# Log Bucket and Sink in same project #
#-------------------------------------#
module "log_export_same_proj" {
  source                 = "../../../"
  destination_uri        = module.dest_same_proj.destination_uri
  filter                 = "resource.type = gce_instance"
  log_sink_name          = "logbucket_same_project"
  parent_resource_id     = var.project_destination_logbkt_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "dest_same_proj" {
  source                        = "../../..//modules/logbucket"
  project_id                    = var.project_destination_logbkt_id
  name                          = "logbucket_from_same_project_${random_string.suffix.result}"
  location                      = "global"
  log_sink_writer_identity      = module.log_export_same_proj.writer_identity
  grant_write_permission_on_bkt = false
}
