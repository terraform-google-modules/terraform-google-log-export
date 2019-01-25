output "pubsub_topic_name" {
  value = "projects/${module.splunk-sink.destination["project"]}/topics/${module.splunk-sink.destination["name"]}"
}

output "pubsub_topic_project" {
  value = "${module.splunk-sink.destination["project"]}"
}

output "pubsub_subscription_name" {
  value = "${module.splunk-sink.pubsub_subscription}"
}

output "pubsub_subscriber" {
  value = "${module.splunk-sink.pubsub_subscriber}"
}
