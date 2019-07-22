# Log Export: Storage destination submodule

This submodule allows you to configure a Google Cloud Storage bucket destination that
can be used by the log export created in the root module.

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a storage bucket destination and a log export at the project level:

```hcl
module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "storage_example_logsink"
  parent_resource_id     = "sample-project"
  parent_resource_type   = "project"
  unique_writer_identity = "true"
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = "sample-project"
  storage_bucket_name      = "sample_storage_bucket"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
}
```

At first glance that example seems like a circular dependency as each module declaration is
using an output from the other, however Terraform is able to collect and order all the resources
so that all dependencies are met.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| location | The location of the storage bucket. | string | `"US"` | no |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | string | n/a | yes |
| project\_id | The ID of the project in which the storage bucket will be created. | string | n/a | yes |
| storage\_bucket\_name | The name of the storage bucket to be created and used for log entries matching the filter. | string | n/a | yes |
| storage\_class | The storage class of the storage bucket. | string | `"MULTI_REGIONAL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| console\_link | The console link to the destination storage bucket |
| destination\_uri | The destination URI for the storage bucket. |
| project | The project in which the storage bucket was created. |
| resource\_id | The resource id for the destination storage bucket |
| resource\_name | The resource name for the destination storage bucket |
| self\_link | The self_link URI for the destination storage bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
