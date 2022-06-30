# Log Export: Log Bucket destination submodule

This submodule allows you to configure a Logging Log bucket destination that
can be used by the log export created in the root module.

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a Cloud Log Bucket destination and a log export at the folder level:

```hcl
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "log_export" {
  source               = "../../../"
  destination_uri      = module.destination.destination_uri
  filter               = "resource.type = gce_instance"
  log_sink_name        = "logbucket_folder_${random_string.suffix.result}"
  parent_resource_id   = var.parent_resource_id
  parent_resource_type = "folder"
}

module "destination" {
  source     = "../../..//modules/logbucket"
  project_id = var.project_id
  name       = "logbucket_folder_${random_string.suffix.result}"
  location   = "global"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The location of the log bucket. | `string` | `"global"` | no |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | `string` | n/a | yes |
| name | The name of the log bucket to be created and used for log entries matching the filter. | `string` | n/a | yes |
| project\_id | The ID of the project in which the log bucket will be created. | `string` | n/a | yes |
| retention\_days | The number of days data should be retained for the log bucket. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| console\_link | The console link to the destination log buckets |
| destination\_uri | The destination URI for the log bucket. |
| project | The project in which the log bucket was created. |
| resource\_name | The resource name for the destination log bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
