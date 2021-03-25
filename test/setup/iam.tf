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

locals {
  log_export_required_roles = [
    # Needed for the Pubsub submodule to create a service account for the
    # subscription it creates
    "roles/iam.serviceAccountAdmin",

    # Needed for the cloud storage submodule to create/delete a bucket
    "roles/storage.admin",

    # Needed for the pubsub submodule to create/delete a pubsub topic
    "roles/pubsub.admin",

    # Needed for the bigquery submodule to create/delete a bigquery dataset
    "roles/bigquery.dataOwner",

    # Needed for the root module to activate APIs
    "roles/serviceusage.serviceUsageAdmin",

    # Needed for the Pubsub submodule to assign roles/bigquery.dataEditor to
    # the service account it creates
    "roles/resourcemanager.projectIamAdmin",

    # Required to create log sinks from the project level
    "roles/logging.configWriter",

    # Needed for the bq-log-alerting submodule to create/delete a cloud function
    "roles/cloudfunctions.developer",

    # Needed for the bq-log-alerting submodule to grant service account roles
    "roles/iam.serviceAccountUser",

    # Needed for the bq-log-alerting submodule to create/delete a cloud scheduler job
    "roles/cloudscheduler.admin"
  ]

  log_export_billing_account_roles = [
    # Required to associate billing accounts to new projects
    "roles/billing.user",
  ]

  log_export_organization_roles = [
    # Required to create log sinks from the organization level on down
    "roles/logging.configWriter",

    # Required to associate billing accounts to new projects
    "roles/billing.projectManager",

    # Required to create a Security Center Source
    "roles/securitycenter.sourcesEditor",

    # Required to get/set IAM policies
    "roles/resourcemanager.organizationAdmin",
  ]

  log_export_folder_roles = [
    # Required to spin up a project within the log_export folder
    "roles/resourcemanager.projectCreator",

    # Required to create log sinks from the folder level
    "roles/logging.configWriter",
  ]
}

resource "google_service_account" "int_test" {
  project      = module.project.project_id
  account_id   = "ci-account"
  display_name = "ci-account"
}

resource "google_project_iam_member" "int_test" {
  for_each = toset(local.log_export_required_roles)

  project = module.project.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_billing_account_iam_member" "int_test" {
  for_each = toset(local.log_export_billing_account_roles)

  billing_account_id = var.billing_account
  role               = each.value
  member             = "serviceAccount:${google_service_account.int_test.email}"
}

# roles/logging.configWriter is needed at the organization level to be able to
# test organization level log sinks.
resource "google_organization_iam_member" "int_test" {
  for_each = toset(local.log_export_organization_roles)

  org_id = var.org_id
  role   = each.value
  member = "serviceAccount:${google_service_account.int_test.email}"
}

# There is a test in the log-exports module that needs to spin up a project
# within a folder, and then reference that project within the test. Because
# of that test we need to assign roles/resourcemanager.projectCreator on the
# folder we're using for log-exports
resource "google_folder_iam_member" "int_test" {
  for_each = toset(local.log_export_folder_roles)

  folder = var.folder_id
  role   = each.value
  member = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}

resource "null_resource" "wait_permissions" {
  # Adding a pause as a workaround for of the provider issue
  # https://github.com/terraform-providers/terraform-provider-google/issues/1131
  provisioner "local-exec" {
    command = "echo sleep 120s for permissions to get granted; sleep 120"
  }
  depends_on = [
    google_billing_account_iam_member.int_test,
    google_folder_iam_member.int_test,
    google_organization_iam_member.int_test,
    google_project_iam_member.int_test
  ]
}
