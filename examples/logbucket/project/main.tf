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
  name                     = "logbucket_project_from_${var.parent_resource_project}"
  location                 = "global"
  log_sink_writer_identity = module.log_export.writer_identity
}

#-------------------------------------#
# Log Bucket and Sink in same project #
#-------------------------------------#
module "log_export_same_project_example" {
  source                 = "../../../"
  destination_uri        = module.destination_same_project_example.destination_uri
  filter                 = "resource.type = gce_instance"
  log_sink_name          = "logbucket_same_project"
  parent_resource_id     = var.project_destination_logbkt_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "destination_same_project_example" {
  source                        = "../../..//modules/logbucket"
  project_id                    = var.project_destination_logbkt_id
  name                          = "logbucket_project_from_${var.project_destination_logbkt_id}"
  location                      = "global"
  log_sink_writer_identity      = module.log_export_same_project_example.writer_identity
  grant_write_permission_on_bkt = false
  retention_days                = 20
}
