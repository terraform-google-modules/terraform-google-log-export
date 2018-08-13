#!/usr/bin/env bats

# #################################### #
#             Terraform tests          #
# #################################### #

@test "Ensure that Terraform configures the dirs and download the plugins" {

  run terraform init
  [ "$status" -eq 0 ]
}

@test "Ensure that Terraform updates the plugins" {

  run terraform get
  [ "$status" -eq 0 ]
}

@test "Terraform plan, ensure connection and creation of resources" {

  run terraform plan
  [ "$status" -eq 0 ]
  [[ "$output" =~ 16\ to\ add ]]
  [[ "$output" =~ 0\ to\ change ]]
  [[ "$output" =~ 0\ to\ destroy ]]
}

@test "Terraform apply" {

  run terraform apply -auto-approve
  [ "$status" -eq 0 ]
  [[ "$output" =~ 16\ added ]]
  [[ "$output" =~ 0\ changed ]]
  [[ "$output" =~ 0\ destroyed ]]
}

# #################################### #
#             gcloud tests             #
# #################################### #

@test "Test if destination APIs are activated" {

  export PROJECT_ID="$(terraform output project_id)"
  run gcloud config set project $PROJECT_ID
  result=$(gcloud services list | grep bigquery-json.googleapis.com)
  [ "$result" = "bigquery-json.googleapis.com" ]
  result=$(gcloud services list | grep storage-api.googleapis.com)
  [ "$result" = "storage-api.googleapis.com" ]
  result=$(gcloud services list | grep pubsub.googleapis.com)
  [ "$result" = "pubsub.googleapis.com" ]
}

@test "Test if Pub/Sub logsink (project-level) exists" {

  export PROJECT_ID="$(terraform output project_id)"
  export SINK_NAME="$(terraform output pubsub_sink_name)"
  export SINK_DESTINATION="$(terraform output pubsub_sink_destination_link)"
  export SINK_WRITER="$(terraform output pubsub_sink_writer)"

  run gcloud logging sinks describe $SINK_NAME --project=$PROJECT_ID
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" = "destination: $SINK_DESTINATION" ]]
  [[ "${lines[2]}" = "name: $SINK_NAME" ]]
  [[ "${lines[3]}" = "writerIdentity: $SINK_WRITER" ]]
}

@test "Test if Storage logsink (folder-level) exists" {

  export FOLDER_ID="$(terraform output folder_id)"
  export SINK_NAME="$(terraform output storage_sink_name)"
  export SINK_DESTINATION="$(terraform output storage_sink_destination_link)"
  export SINK_WRITER="$(terraform output storage_sink_writer)"

  run gcloud logging sinks describe $SINK_NAME --folder=$FOLDER_ID
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" = "destination: $SINK_DESTINATION" ]]
  [[ "${lines[2]}" = "includeChildren: true" ]]
  [[ "${lines[3]}" = "name: $SINK_NAME" ]]
  [[ "${lines[4]}" = "writerIdentity: $SINK_WRITER" ]]
}

@test "Test if BigQuery logsink (organization-level) exists" {

  export ORG_ID="$(terraform output org_id)"
  export SINK_NAME="$(terraform output bigquery_sink_name)"
  export SINK_DESTINATION="$(terraform output bigquery_sink_destination_link)"
  export SINK_WRITER="$(terraform output bigquery_sink_writer)"

  run gcloud logging sinks describe $SINK_NAME --organization=$ORG_ID
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" = "destination: $SINK_DESTINATION" ]]
  [[ "${lines[2]}" = "includeChildren: true" ]]
  [[ "${lines[3]}" = "name: $SINK_NAME" ]]
  [[ "${lines[4]}" = "writerIdentity: $SINK_WRITER" ]]
}

@test "Test if service account has correct permissions to write to Pub/Sub logsink" {
  export PROJECT_ID="$(terraform output project_id)"
  export SINK_WRITER="$(terraform output pubsub_sink_writer)"

  run gcloud projects get-iam-policy $PROJECT_ID --flatten='bindings[].members' --format='table(bindings.role)' --filter=bindings.members:$SINK_WRITER
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" = "roles/pubsub.publisher" ]]
}

@test "Test if service account has correct permissions to write to Storage logsink" {
  export PROJECT_ID="$(terraform output project_id)"
  export SINK_WRITER="$(terraform output storage_sink_writer)"

  run gcloud projects get-iam-policy $PROJECT_ID --flatten='bindings[].members' --format='table(bindings.role)' --filter=bindings.members:$SINK_WRITER
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" = "roles/storage.objectCreator" ]]
}

@test "Test if service account has correct permissions to write to BigQuery logsink" {
  export PROJECT_ID="$(terraform output project_id)"
  export SINK_WRITER="$(terraform output bigquery_sink_writer)"

  run gcloud projects get-iam-policy $PROJECT_ID --flatten='bindings[].members' --format='table(bindings.role)' --filter=bindings.members:$SINK_WRITER
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" = "roles/bigquery.dataEditor" ]]
}

# #################################### #
#      Terraform destroy test          #
# #################################### #

@test "Terraform destroy" {

  run terraform destroy -force
  [ "$status" -eq 0 ]
  [[ "$output" =~ 16\ destroyed ]]
}
