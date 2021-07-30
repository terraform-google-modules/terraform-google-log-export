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
  unique_writer_identity = true
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/pubsub"
  project_id               = "sample-project"
  topic_name               = "sample-topic"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
  create_subscriber        = true
}
```

At first glance that example seems like a circular dependency as each module declaration is
using an output from the other, however Terraform is able to collect and order all the resources
so that all dependencies are met.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_push\_subscriber | Whether to add a push configuration to the subcription. If 'true', a push subscription is created along with a service account that is granted roles/pubsub.subscriber and roles/pubsub.viewer to the topic. | `bool` | `false` | no |
| create\_subscriber | Whether to create a subscription to the topic that was created and used for log entries matching the filter. If 'true', a pull subscription is created along with a service account that is granted roles/pubsub.subscriber and roles/pubsub.viewer to the topic. | `bool` | `false` | no |
| kms\_key\_name | ID of a Cloud KMS CryptoKey to be used to protect access to messages published on this topic. Your project's PubSub service account requires access to this encryption key. | `string` | `null` | no |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | `string` | n/a | yes |
| project\_id | The ID of the project in which the pubsub topic will be created. | `string` | n/a | yes |
| push\_endpoint | The URL locating the endpoint to which messages should be pushed. | `string` | `""` | no |
| subscriber\_id | The ID to give the pubsub pull subscriber service account (optional). | `string` | `""` | no |
| subscription\_labels | A set of key/value label pairs to assign to the pubsub subscription. | `map(string)` | `{}` | no |
| topic\_labels | A set of key/value label pairs to assign to the pubsub topic. | `map(string)` | `{}` | no |
| topic\_name | The name of the pubsub topic to be created and used for log entries matching the filter. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| console\_link | The console link to the destination storage bucket |
| destination\_uri | The destination URI for the topic. |
| project | The project in which the topic was created. |
| pubsub\_push\_subscription | Pub/Sub push subscription id (if any) |
| pubsub\_subscriber | Pub/Sub subscriber email (if any) |
| pubsub\_subscription | Pub/Sub subscription id (if any) |
| resource\_id | The resource id for the destination topic |
| resource\_name | The resource name for the destination topic |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Customer Managed Encryption Key permission

Your project's PubSub service account `service-{{PROJECT_NUMBER}}@gcp-sa-pubsub.iam.gserviceaccount.com` must have `roles/cloudkms.cryptoKeyEncrypterDecrypter` to use this feature.
