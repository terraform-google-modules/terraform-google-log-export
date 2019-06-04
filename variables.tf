variable "filters" {
  description = "The filters to apply when exporting logs. Only log entries that match the filter are exported. Default is '' which exports all logs."
  type        = "list"
}

variable "include_children" {
  description = "Only valid if 'organization' or 'folder' is chosen as var.parent_resource.type. Determines whether or not to include children organizations/folders in the sink export. If true, logs associated with child projects are also exported; otherwise only logs relating to the provided organization/folder are included."
  default     = "false"
}

variable "sink_names" {
  description = "The name of the log sinks to be created."
  type        = "list"
}

variable "parent_resource_id" {
  description = "The ID of the GCP resource in which you create the log sink. If var.parent_resource_type is set to 'project', then this is the Project ID (and etc)."
}

variable "parent_resource_type" {
  description = "The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing_account', or 'organization'."
  default     = "project"
}

variable "unique_writer_identity" {
  description = "Whether or not to create a unique identity associated with this sink. If false (the default), then the writer_identity used is serviceAccount:cloud-logs@system.gserviceaccount.com. If true, then a unique service account is created and used for the logging sink."
  default     = "false"
}

variable "destination_uris" {
  description = "Destination URIs (PubSub topic, Storage bucket, BigQuery dataset)"
  default     = [""]
}
