output "sink_parent_id" {
  description = "Sink parent resource id"
  value       = "${module.sink.sink_parent_id}"
}

output "sink_parent_type" {
  description = "Sink parent resource type (organization, folder, project)"
  value       = "${module.sink.sink_parent_type}"
}

output "sink_writer_identities" {
  description = "Map of sink names to sink writer identities"
  value       = "${zipmap(var.sink_names, module.sink.sink_writer_identities)}"
}

output "sink_resource_ids" {
  description = "Map of sink names to sink resource ids"
  value       = "${zipmap(var.sink_names, module.sink.sink_resource_ids)}"
}
