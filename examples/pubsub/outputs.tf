output "org_sink" {
  value = "${module.org_sink.sink}"
}

output "org_sink_destination" {
  value = "${module.org_sink.destination}"
}

output "folder_sink" {
  value = "${module.folder_sink.sink}"
}

output "folder_sink_destination" {
  value = "${module.folder_sink.destination}"
}

output "folder_name" {
  value = "${var.folder}"
}

output "project_sink" {
  value = "${module.project_sink.sink}"
}

output "project_sink_destination" {
  value = "${module.project_sink.destination}"
}
