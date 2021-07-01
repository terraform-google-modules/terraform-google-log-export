# Log Export: Storage destination submodule

This submodule allows you to configure a Google Cloud Logging bucket destination that
can be used by the log export created in the root module.

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a logging bucket destination and a log export at the project level:

```hcl
module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "storage_example_logsink"
  parent_resource_id     = "sample-project"
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/log-bucket"
  project_id               = "sample-project"
  bucket_id      = "sample_storage_bucket"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
}
```

At first glance that example seems like a circular dependency as each module declaration is
using an output from the other, however Terraform is able to collect and order all the resources
so that all dependencies are met.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_description"></a> [bucket\_description](#input\_bucket\_description) | Log bucket description. | `string` | `null` | no |
| <a name="input_bucket_id"></a> [bucket\_id](#input\_bucket\_id) | The name of the log bucket to be created or used for log entries matching the filter. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the storage bucket. | `string` | `"global"` | no |
| <a name="input_log_sink_writer_identity"></a> [log\_sink\_writer\_identity](#input\_log\_sink\_writer\_identity) | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the storage bucket will be created. | `string` | n/a | yes |
| <a name="input_retention_days"></a> [retention\_days](#input\_retention\_days) | Log retention in days. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_uri"></a> [destination\_uri](#output\_destination\_uri) | The destination URI for the logging bucket. |
| <a name="output_project"></a> [project](#output\_project) | The project in which the logging bucket was created. |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The resource id for the destination logging bucket |
| <a name="output_resource_name"></a> [resource\_name](#output\_resource\_name) | The resource name for the destination logging bucket |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The self\_link URI for the destination logging bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
