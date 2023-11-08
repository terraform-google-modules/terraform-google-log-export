# Log Export: Log Bucket destination submodule

This submodule allows you to configure a [Logging Log bucket destination](https://cloud.google.com/logging/docs/routing/overview#destinations) that
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
| enable\_analytics | (Optional) Whether or not Log Analytics is enabled. A Log bucket with Log Analytics enabled can be queried in the Log Analytics page using SQL queries. Cannot be disabled once enabled. | `bool` | `false` | no |
| grant\_write\_permission\_on\_bkt | (Optional) Indicates whether the module is responsible for granting write permission on the logbucket. This permission will be given by default, but if the user wants, this module can skip this step. This is the case when the sink route logs to a log bucket in the same Cloud project, no new service account will be created and this module will need to bypass granting permissions. | `bool` | `true` | no |
| kms\_key\_name | To enable CMEK for a project logging bucket, set this field to a valid name. The associated service account requires cloudkms.cryptoKeyEncrypterDecrypter roles assigned for the key.The kms\_key\_name should be of the format projects/{project ID}/locations/{region}/keyRings/{keyring name}/cryptoKeys/{key name} | `string` | `null` | no |
| linked\_dataset\_description | A use-friendly description of the linked BigQuery dataset. The maximum length of the description is 8000 characters. | `string` | `null` | no |
| linked\_dataset\_id | The ID of the linked BigQuery dataset. A valid link dataset ID must only have alphanumeric characters and underscores within it and have up to 100 characters. | `string` | `null` | no |
| location | The location of the log bucket. | `string` | `"global"` | no |
| locked | (Optional) Whether the bucket is locked. The retention period on a locked bucket cannot be changed. Locked buckets may only be deleted if they are empty | `bool` | `null` | no |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | `string` | n/a | yes |
| name | The name of the log bucket to be created and used for log entries matching the filter. | `string` | n/a | yes |
| project\_id | The ID of the project in which the log bucket will be created. | `string` | n/a | yes |
| retention\_days | The number of days data should be retained for the log bucket. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| console\_link | The console link to the destination log buckets |
| destination\_uri | The destination URI for the log bucket. |
| linked\_dataset\_name | The resource name of the linked BigQuery dataset. |
| project | The project in which the log bucket was created. |
| resource\_name | The resource name for the destination log bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
