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

module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 9.0"

  destination_uri        = module.destination.destination_uri
  log_sink_name          = "storage_example_logsink"
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = "billing_account"
  unique_writer_identity = true
}

module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/storage"
  version = "~> 9.0"

  project_id               = var.project_id
  storage_bucket_name      = "storage_example_bucket"
  log_sink_writer_identity = module.log_export.writer_identity
  versioning               = true
}

