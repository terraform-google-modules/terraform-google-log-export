# Log Export: PubSub destination submodule

This submodule allows you to configure a PubSub topic destination that
can be used by the log export created in the root module.

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a PubSub topic destination and a log export at the project level:

```hcl
module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "pubsub_example_logsink"
  parent_resource_id     = "sample-project"
  parent_resource_type   = "project"
  unique_writer_identity = "true"
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/pubsub"
  project_id               = "sample-project"
  topic_name               = "sample-topic"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
  create_subscriber        = "true"
}
```

At first glance that example seems like a circular dependency as each module declaration is
using an output from the other, however Terraform is able to collect and order all the resources
so that all dependencies are met.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_subscriber | Whether to create a subscription to the topic that was created and used for log entries matching the filter. If 'true', a subscription is created along with a service account that is granted roles/pubsub.subscriber and roles/pubsub.viewer to the topic. | string | `"false"` | no |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | string | n/a | yes |
| project\_id | The ID of the project in which the pubsub topic will be created. | string | n/a | yes |
| topic\_labels | A set of key/value label pairs to assign to the pubsub topic. | map | `<map>` | no |
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

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
