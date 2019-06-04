# Log Export: PubSub destination submodule

This submodule allows you to configure a PubSub topic destination that
can be used by the log export created in the root module.

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a PubSub topic destination and a log export at the project level:

```hcl
module "log_exports" {
  source                 = "terraform-google-modules/log-export/google//modules/pubsub"
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

  pubsub_topic_names = [
    "test-storage-1",
    "test-storage-2",
  ]
}
```

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_subscriber | Whether to create a subscription to the topic that was created and used for log entries matching the filter. If 'true', a subscription is created along with a service account that is granted roles/pubsub.subscriber and roles/pubsub.viewer to the topic. | string | `"false"` | no |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | string | n/a | yes |
| project\_id | The ID of the project in which the pubsub topic will be created. | string | n/a | yes |
| topic\_name | The name of the pubsub topic to be created and used for log entries matching the filter. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| console\_link | The console link to the destination storage bucket |
| destination\_uri | The destination URI for the topic. |
| project | The project in which the topic was created. |
| pubsub\_subscriber | Pub/Sub subscriber email (if any) |
| pubsub\_subscription | Pub/Sub subscription id (if any) |
| resource\_id | The resource id for the destination topic |
| resource\_name | The resource name for the destination topic |

[^]: (autogen_docs_end)
