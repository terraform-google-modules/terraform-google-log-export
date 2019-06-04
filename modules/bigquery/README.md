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
| bigquery\_dataset\_location | The location of the storage bucket. | string | `"US"` | no |
| bigquery\_dataset\_names | The name of the bigquery datasets to be created and used for log entries matching the filter. | list | n/a | yes |
| bigquery\_delete\_contents\_on\_destroy | Delete dataset contents on destroy | string | `"true"` | no |
| destination\_project\_id | The ID of the project in which the bigquery dataset will be created. | string | n/a | yes |
| destination\_uris | Destination URIs (PubSub topic, Storage bucket, BigQuery dataset) | list | `<list>` | no |
| filters | The filters to apply when exporting logs. Only log entries that match the filter are exported. Default is '' which exports all logs. | list | n/a | yes |
| include\_children | Only valid if 'organization' or 'folder' is chosen as var.parent_resource.type. Determines whether or not to include children organizations/folders in the sink export. If true, logs associated with child projects are also exported; otherwise only logs relating to the provided organization/folder are included. | string | `"false"` | no |
| parent\_resource\_id | The ID of the GCP resource in which you create the log sink. If var.parent_resource_type is set to 'project', then this is the Project ID (and etc). | string | n/a | yes |
| parent\_resource\_type | The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing_account', or 'organization'. | string | `"project"` | no |
| sink\_names | The name of the log sinks to be created. | list | n/a | yes |
| unique\_writer\_identity | Whether or not to create a unique identity associated with this sink. If false (the default), then the writer_identity used is serviceAccount:cloud-logs@system.gserviceaccount.com. If true, then a unique service account is created and used for the logging sink. | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| console\_links | Map of log sink names to the BigQuery dataset' console links |
| destination\_project | The project in which the BigQuery dataset were created |
| destination\_resource\_ids | Map of log sink names to the BigQuery dataset' resource ids |
| destination\_resource\_names | Map of log sink names to the BigQuery dataset' names |
| destination\_uris | Map of log sink names to the BigQuery dataset' URIs |
| sink\_parent\_id | Sink parent resource id |
| sink\_parent\_type | Sink parent resource type (organization, folder, project) |
| sink\_resource\_ids | Map of sink names to sink resource ids |
| sink\_writer\_identities | Map of sink names to sink writer identities |

[^]: (autogen_docs_end)
