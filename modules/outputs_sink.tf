output "sink_parent_id" {
  value = "${module.sink.sink_parent_id}"
}

output "sink_parent_type" {
  value = "${module.sink.sink_parent_type}"
}

output "sink_writer_identities" {
  value = "${zipmap(var.sink_names, module.sink.sink_writer_identities)}"
}

output "sink_resource_ids" {
  value = "${zipmap(var.sink_names, module.sink.sink_resource_ids)}"
}
