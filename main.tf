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

#-----------------#
# Local variables #
#-----------------#
locals {
  is_project_level = var.parent_resource_type == "project"
  is_folder_level  = var.parent_resource_type == "folder"
  is_org_level     = var.parent_resource_type == "organization"
  is_billing_level = var.parent_resource_type == "billing_account"

  # Locals for outputs to ensure the value is available after the resource is created
  log_sink_writer_identity = local.is_project_level ? element(concat(google_logging_project_sink.sink.*.writer_identity, [""]), 0) : local.is_folder_level ? element(concat(google_logging_folder_sink.sink.*.writer_identity, [""]), 0) : local.is_org_level ? element(concat(google_logging_organization_sink.sink.*.writer_identity, [""]), 0) : local.is_billing_level ? element(concat(google_logging_billing_account_sink.sink.*.writer_identity, [""]), 0) : ""
  log_sink_resource_id     = local.is_project_level ? element(concat(google_logging_project_sink.sink.*.id, [""]), 0) : local.is_folder_level ? element(concat(google_logging_folder_sink.sink.*.id, [""]), 0) : local.is_org_level ? element(concat(google_logging_organization_sink.sink.*.id, [""]), 0) : local.is_billing_level ? element(concat(google_logging_billing_account_sink.sink.*.id, [""]), 0) : ""
  log_sink_resource_name   = local.is_project_level ? element(concat(google_logging_project_sink.sink.*.name, [""]), 0) : local.is_folder_level ? element(concat(google_logging_folder_sink.sink.*.name, [""]), 0) : local.is_org_level ? element(concat(google_logging_organization_sink.sink.*.name, [""]), 0) : local.is_billing_level ? element(concat(google_logging_billing_account_sink.sink.*.name, [""]), 0) : ""
  log_sink_parent_id       = local.is_project_level ? element(concat(google_logging_project_sink.sink.*.project, [""]), 0) : local.is_folder_level ? element(concat(google_logging_folder_sink.sink.*.folder, [""]), 0) : local.is_org_level ? element(concat(google_logging_organization_sink.sink.*.org_id, [""]), 0) : local.is_billing_level ? element(concat(google_logging_billing_account_sink.sink.*.billing_account, [""]), 0) : ""

  # Bigquery sink options
  bigquery_options = var.bigquery_options == null ? [] : var.unique_writer_identity == true ? tolist([var.bigquery_options]) : []
}


#-----------#
# Log sinks #
#-----------#
# Project-level
resource "google_logging_project_sink" "sink" {
  count                  = local.is_project_level ? 1 : 0
  name                   = var.log_sink_name
  project                = var.parent_resource_id
  filter                 = var.filter
  destination            = var.destination_uri
  unique_writer_identity = var.unique_writer_identity
  dynamic "bigquery_options" {
    for_each = local.bigquery_options
    content {
      use_partitioned_tables = bigquery_options.value.use_partitioned_tables
    }
  }

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
      disabled    = exclusions.value.disabled
    }
  }
}

# Folder-level
resource "google_logging_folder_sink" "sink" {
  count            = local.is_folder_level ? 1 : 0
  name             = var.log_sink_name
  folder           = var.parent_resource_id
  filter           = var.filter
  include_children = var.include_children
  destination      = var.destination_uri
  dynamic "bigquery_options" {
    for_each = local.bigquery_options
    content {
      use_partitioned_tables = bigquery_options.value.use_partitioned_tables
    }
  }

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
      disabled    = exclusions.value.disabled
    }
  }
}

# Org-level
resource "google_logging_organization_sink" "sink" {
  count            = local.is_org_level ? 1 : 0
  name             = var.log_sink_name
  org_id           = var.parent_resource_id
  filter           = var.filter
  include_children = var.include_children
  destination      = var.destination_uri
  dynamic "bigquery_options" {
    for_each = local.bigquery_options
    content {
      use_partitioned_tables = bigquery_options.value.use_partitioned_tables
    }
  }

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
      disabled    = exclusions.value.disabled
    }
  }
}

# Billing Account-level
resource "google_logging_billing_account_sink" "sink" {
  count           = local.is_billing_level ? 1 : 0
  name            = var.log_sink_name
  billing_account = var.parent_resource_id
  filter          = var.filter
  destination     = var.destination_uri
  dynamic "bigquery_options" {
    for_each = local.bigquery_options
    content {
      use_partitioned_tables = bigquery_options.value.use_partitioned_tables
    }
  }

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
      disabled    = exclusions.value.disabled
    }
  }
}
