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

/*****************************
  Provider configuration
 ****************************/
provider "google" {
  version = "~> 3.30"
}

module "bq-log-alerting" {
  source          = "../..//modules/bq-log-alerting"
  logging_project = var.logging_project
  region          = "us-east4"
  org_id          = var.org_id
  source_name     = var.source_name
  dry_run         = false
}
