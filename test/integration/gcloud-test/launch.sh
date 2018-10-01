#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#################################################################
#   PLEASE FILL THE VARIABLES WITH VALID VALUES FOR TESTING     #
#   DO NOT REMOVE ANY OF THE VARIABLES                          #
#################################################################

export PROJECT_ID="XXXXXXXXX"
export ORG_ID="XXXXXXXXXXXX"
export FOLDER_ID="XXXXXXXXXXXXX"
export BILLING_ID="XXXXXX-XXXXXX-XXXXXX"
export CREDENTIALS_PATH="XXXXXX"
export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS_PATH
export SINK_NAME="integration-sink"
export STORAGE_BUCKET="<PREFIX>-integration-sink"
export BIGQUERY_DATASET="integration_sink"
export PUBSUB_TOPIC="integration-sink"

# Cleans the workdir
function clean_workdir() {
  echo "Cleaning workdir"
  yes | rm -f terraform.tfstate*
  yes | rm -f *.tf
  yes | rm -rf .terraform
}

# Creates the main.tf file for Terraform
function create_main_tf_file() {
  echo "Creating main.tf file"
  touch main.tf
  cat <<EOF > main.tf
locals {
  credentials_file_path = "$CREDENTIALS_PATH"
}

provider "google" {
  credentials = "\${file(local.credentials_file_path)}"
}

module "pubsub_sink" {
  source = "../../../"
  name   = "integration-project-sink-pubsub"
  project = "$PROJECT_ID"
  pubsub = {
    name    = "$PUBSUB_TOPIC"
    project = "$PROJECT_ID"
    create_subscriber = true
  }
}

module "storage_sink" {
  source = "../../../"
  name   = "integration-folder-sink-storage"
  folder = "$FOLDER_ID"
  storage = {
    name    = "$STORAGE_BUCKET"
    project = "$PROJECT_ID"
  }
}

module "bigquery_sink" {
  source = "../../../"
  name   = "integration-org-sink-bigquery"
  org_id = "$ORG_ID"
  bigquery = {
    name     = "$BIGQUERY_DATASET"
    project  = "$PROJECT_ID"
  }
}
EOF
}

# Creates the outputs.tf file
function create_outputs_file() {
  echo "Creating outputs.tf file"
  touch outputs.tf
  cat <<'EOF' > outputs.tf

  output "project_id" {
    value = "${module.pubsub_sink.sink["resource_name"]}"
  }

  output "folder_id" {
    value = "${module.storage_sink.sink["resource_name"]}"
  }

  output "org_id" {
    value = "${module.bigquery_sink.sink["resource_name"]}"
  }

  # Pub/Sub
  output "pubsub_sink_name" {
    value = "${module.pubsub_sink.sink["name"]}"
  }

  output "pubsub_sink_writer" {
    value = "${module.pubsub_sink.sink["writer"]}"
  }

  output "pubsub_sink_subscriber" {
    value = "${module.pubsub_sink.pubsub_subscriber}"
  }

  output "pubsub_sink_destination_link" {
    value = "${module.pubsub_sink.destination["self_link"]}"
  }

  output "pubsub_sink_destination_project" {
    value = "${module.pubsub_sink.destination["project"]}"
  }

  output "pubsub_sink_destination_name" {
    value = "${module.pubsub_sink.destination["name"]}"
  }

  # Storage
  output "storage_sink_name" {
    value = "${module.storage_sink.sink["name"]}"
  }

  output "storage_sink_writer" {
    value = "${module.storage_sink.sink["writer"]}"
  }

  output "storage_sink_destination_link" {
    value = "${module.storage_sink.destination["self_link"]}"
  }

  output "storage_sink_destination_project" {
    value = "${module.storage_sink.destination["project"]}"
  }

  output "storage_sink_destination_name" {
    value = "${module.storage_sink.destination["name"]}"
  }

  # BigQuery
  output "bigquery_sink_name" {
    value = "${module.bigquery_sink.sink["name"]}"
  }

  output "bigquery_sink_writer" {
    value = "${module.bigquery_sink.sink["writer"]}"
  }

  output "bigquery_sink_destination_link" {
    value = "${module.bigquery_sink.destination["self_link"]}"
  }

  output "bigquery_sink_destination_project" {
    value = "${module.bigquery_sink.destination["project"]}"
  }

  output "bigquery_sink_destination_name" {
    value = "${module.bigquery_sink.destination["name"]}"
  }
EOF
}

# Preparing environment
clean_workdir
create_main_tf_file
create_outputs_file

# Call to bats
echo "Test to execute: $(bats integration.bats -c)"
bats integration.bats

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=""
unset CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE

# Clean the environment
clean_workdir
echo "Integration test finished"
