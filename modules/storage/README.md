# Log Export: Storage destination submodule

This submodule allows you to configure a Google Cloud Storage bucket destination that
can be used by the log export created in the root module.

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a storage bucket destination and a log export at the project level:

```hcl
module "log_exports" {
  source                 = "terraform-google-modules/log-export/google//modules/storage"
  parent_resource_id     = "234354564998"
  parent_resource_type   = "organization"
  destination_project_id = "test-log-exports"
  include_children       = "true"

  sink_names = [
    "test-sink-1",
    "test-sink-2",
  ]

  sink_filters = [
    "organizations/465421231564/logs/cloudaudit.googleapis.com%2Factivity",
    "organizations/465421231564/logs/cloudaudit.googleapis.com%2Fsystem_event",
  ]

  storage_bucket_names = [
    "test-bq-1",
    "test-bq-2",
  ]
}
```

At first glance that example seems like a circular dependency as each module declaration is
using an output from the other, however Terraform is able to collect and order all the resources
so that all dependencies are met.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | string | n/a | yes |
| project\_id | The ID of the project in which the storage bucket will be created. | string | n/a | yes |
| storage\_bucket\_name | The name of the storage bucket to be created and used for log entries matching the filter. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| console\_link | The console link to the destination storage bucket |
| destination\_uri | The destination URI for the storage bucket. |
| project | The project in which the storage bucket was created. |
| resource\_id | The resource id for the destination storage bucket |
| resource\_name | The resource name for the destination storage bucket |
| self\_link | The self_link URI for the destination storage bucket |

[^]: (autogen_docs_end)
