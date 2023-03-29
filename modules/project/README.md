# Log Export: project destination submodule

This submodule allows you to Route log entries to a different [Google Cloud project](https://cloud.google.com/logging/docs/routing/overview#destinations).

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a storage bucket destination and a log export at the project level:

```hcl
module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "storage_example_logsink"
  parent_resource_id     = "sample-project"
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/project"
  version                  = "~> 7.0"
  project_id               = "sample-project"
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
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | `string` | n/a | yes |
| project\_id | The ID of the project to which logs will be routed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| destination\_uri | The destination URI for project. |
| project | The ID of the project to which logs will be routed. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
