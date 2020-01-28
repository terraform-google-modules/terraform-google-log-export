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

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 7.0"

  name              = "ci-log-export"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "oslogin.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "bigquery.googleapis.com",
    "pubsub.googleapis.com",
    "storage-component.googleapis.com",
    "storage-api.googleapis.com",
    "logging.googleapis.com",
    "iam.googleapis.com",
    "cloudbilling.googleapis.com"
  ]
}

resource "null_resource" "wait_apis" {
  # Adding a pause as a workaround for of the provider issue
  # https://github.com/terraform-providers/terraform-provider-google/issues/1131
  provisioner "local-exec" {
    command = "echo sleep 120s for APIs to get enabled; sleep 120"
  }
  depends_on = [module.project.project_id]
}

