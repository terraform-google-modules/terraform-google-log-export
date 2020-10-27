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

module "bq-log-alerting" {
  source               = "../../../modules/bq-log-alerting"
  org_id               = var.org_id
  region               = var.region
  source_name          = var.source_name
  logging_project      = var.logging_project
  job_schedule         = var.job_schedule
  time_window_unit     = var.time_window_unit
  time_window_quantity = var.time_window_quantity
  dry_run              = var.dry_run
  function_timeout     = var.function_timeout
  function_memory      = var.function_memory
}
