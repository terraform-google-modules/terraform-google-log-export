
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
