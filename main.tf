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

#-----------------#
# Local variables #
#-----------------#
locals {
  invalid_parent_resource_type = "${var.parent_resource_type == "project" || var.parent_resource_type == "organization" || var.parent_resource_type == "folder" || var.parent_resource_type == "billing_account" ? 0 : 1 }"
  is_project_level             = "${var.parent_resource_type == "project" ? 1 : 0}"
  is_folder_level              = "${var.parent_resource_type == "folder" ? 1 : 0}"
  is_org_level                 = "${var.parent_resource_type == "organization" ? 1 : 0}"
  is_billing_level             = "${var.parent_resource_type == "billing_account" ? 1 : 0}"
}

#---------------------#
# Variable validation #
#---------------------#
resource "null_resource" "valid_parent_resource_type" {
  count                                                                                                                                                                                          = "${local.invalid_parent_resource_type}"
  "ERROR: Variable `parent_resource_type` must not be a computed value, and must be one of: 'project', 'folder', 'organization', or 'billing_account'. Please correct your value and try again." = true
}

#-----------#
# Log sinks #
#-----------#
# Project-level
resource "google_logging_project_sink" "sink" {
  count                  = "${local.is_project_level ? length(var.sink_names) : 0}"
  project                = "${var.parent_resource_id}"
  name                   = "${var.sink_names[count.index]}"
  filter                 = "${var.filters[count.index]}"
  destination            = "${var.destination_uris[count.index]}"
  unique_writer_identity = "${var.unique_writer_identity}"
}

# Folder-level
resource "google_logging_folder_sink" "sink" {
  count            = "${local.is_folder_level ? length(var.sink_names) : 0}"
  folder           = "${var.parent_resource_id}"
  name             = "${var.sink_names[count.index]}"
  filter           = "${var.filters[count.index]}"
  destination      = "${var.destination_uris[count.index]}"
  include_children = "${var.include_children}"
}

# Org-level
resource "google_logging_organization_sink" "sink" {
  count            = "${local.is_org_level ? length(var.sink_names) : 0}"
  org_id           = "${var.parent_resource_id}"
  name             = "${var.sink_names[count.index]}"
  filter           = "${var.filters[count.index]}"
  destination      = "${var.destination_uris[count.index]}"
  include_children = "${var.include_children}"
}

# Billing Account-level
resource "google_logging_billing_account_sink" "sink" {
  count            = "${local.is_billing_level ? length(var.sink_names) : 0}"
  billing_account  = "${var.parent_resource_id}"
  name             = "${var.sink_names[count.index]}"
  filter           = "${var.filters[count.index]}"
  destination      = "${var.destination_uris[count.index]}"
  include_children = "${var.include_children}"
}
