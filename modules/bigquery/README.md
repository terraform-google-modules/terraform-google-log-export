# Log Export: BigQuery destination submodule

This submodule allows you to configure a BigQuery dataset destination that
can be used by the log export created in the root module.

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a BigQuery dataset destination and a log export at the project level:

```hcl
module "log_exports" {
  source                 = "terraform-google-modules/log-export/google//modules/bigquery"
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

  bigquery_dataset_names = [
    "test-bq-1",
    "test-bq-2",
  ]
}
```

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dataset\_name | The name of the bigquery dataset to be created and used for log entries matching the filter. | string | n/a | yes |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | string | n/a | yes |
| project\_id | The ID of the project in which the bigquery dataset will be created. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| console\_link | The console link to the destination bigquery dataset |
| destination\_uri | The destination URI for the bigquery dataset. |
| project | The project in which the bigquery dataset was created. |
| resource\_id | The resource id for the destination bigquery dataset |
| resource\_name | The resource name for the destination bigquery dataset |
| self\_link | The self_link URI for the destination bigquery dataset |

[^]: (autogen_docs_end)
