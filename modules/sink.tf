module "sink" {
  source                 = "../../"
  filters                = "${var.filters}"
  include_children       = "${var.include_children}"
  sink_names             = "${var.sink_names}"
  parent_resource_id     = "${var.parent_resource_id}"
  parent_resource_type   = "${var.parent_resource_type}"
  unique_writer_identity = "${var.unique_writer_identity}"
  destination_uris       = "${local.destination_uris}"
}
