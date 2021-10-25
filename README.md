# Terraform Log Export Module

This module allows you to create log exports at the project, folder,
organization, or billing account level. Submodules are also available to
configure the destination resource that will store all exported logs. The
resources/services/activations/deletions that this module will create/trigger
are:

- An **Aggregated log export** on the project-level, folder-level, organization-level, or billing-account-level
- A **Service account** (logsink writer)
- A **Destination** (Cloud Storage bucket, Cloud Pub/Sub topic, BigQuery dataset)

## Compatibility
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+. If you find incompatibilities using Terraform >=0.13, please open an issue.
 If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v5.1.0](https://registry.terraform.io/modules/terraform-google-modules/-log-export/google/v5.1.0).

## Usage

The [examples](./examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a Cloud Storage destination and a log export at the project level:

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
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = "sample-project"
  storage_bucket_name      = "storage_example_bucket"
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
| bigquery\_options | (Optional) Options that affect sinks exporting data to BigQuery. use\_partitioned\_tables - (Required) Whether to use BigQuery's partition tables. | <pre>object({<br>    use_partitioned_tables = bool<br>  })</pre> | `null` | no |
| destination\_uri | The self\_link URI of the destination resource (This is available as an output coming from one of the destination submodules) | `string` | n/a | yes |
| exclusions | (Optional) A list of sink exclusion filters. | <pre>list(object({<br>    name        = string,<br>    description = string,<br>    filter      = string,<br>    disabled    = bool<br>  }))</pre> | `[]` | no |
| filter | The filter to apply when exporting logs. Only log entries that match the filter are exported. Default is '' which exports all logs. | `string` | `""` | no |
| include\_children | Only valid if 'organization' or 'folder' is chosen as var.parent\_resource.type. Determines whether or not to include children organizations/folders in the sink export. If true, logs associated with child projects are also exported; otherwise only logs relating to the provided organization/folder are included. | `bool` | `false` | no |
| log\_sink\_name | The name of the log sink to be created. | `string` | n/a | yes |
| parent\_resource\_id | The ID of the GCP resource in which you create the log sink. If var.parent\_resource\_type is set to 'project', then this is the Project ID (and etc). | `string` | n/a | yes |
| parent\_resource\_type | The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing\_account', or 'organization'. | `string` | `"project"` | no |
| unique\_writer\_identity | Whether or not to create a unique identity associated with this sink. If false (the default), then the writer\_identity used is serviceAccount:cloud-logs@system.gserviceaccount.com. If true, then a unique service account is created and used for the logging sink. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| filter | The filter to be applied when exporting logs. |
| log\_sink\_resource\_id | The resource ID of the log sink that was created. |
| log\_sink\_resource\_name | The resource name of the log sink that was created. |
| parent\_resource\_id | The ID of the GCP resource in which you create the log sink. |
| writer\_identity | The service account that logging uses to write log entries to the destination. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin ~> v3.5.x

### Configure a Service Account
In order to execute this module you must have a Service Account with the following:

#### Roles
The service account should have the following roles:
- `roles/logging.configWriter` on the logsink's project, folder, or organization (to create the logsink)
- `roles/resourcemanager.projectIamAdmin` on the destination project (to grant write permissions for logsink service account)
- `roles/serviceusage.serviceUsageAdmin` on the destination project (to enable destination APIs)

#### Pub/Sub roles
To use a Google Cloud Pub/Sub topic as the destination:
- `roles/pubsub.admin` on the destination project (to create a pub/sub topic)

To integrate the logsink with Splunk, you'll need a topic subscriber (service account):
- `roles/iam.serviceAccountAdmin` on the destination project (to create a service account for the logsink subscriber)

#### Storage role
To use a Google Cloud Storage bucket as the destination:
- `roles/storage.admin` on the destination project (to create a storage bucket)

#### BigQuery role
To use a BigQuery dataset as the destination, one must grant:
- `roles/bigquery.dataEditor` on the destination project (to create a BigQuery dataset)

#### BigQuery Options
To use BigQuery `use_partitioned_tables` argument you must also have `unique_writer_identity` set to `true`.

 Usage in module:
 ```
 bigquery_options = {
    use_partitioned_tables = true
  }
```
 Enabling this option will store logs into a single table that is internally partitioned by day which can improve query performance.

### Enable API's
In order to operate with the Service Account you must activate the following API's on the base project where the Service Account was created:

- Cloud Resource Manager API - cloudresourcemanager.googleapis.com
- Cloud Billing API - cloudbilling.googleapis.com
- Identity and Access Management API - iam.googleapis.com
- Service Usage API - serviceusage.googleapis.com
- Stackdriver Logging API - logging.googleapis.com
- Cloud Storage JSON API - storage-api.googleapis.com
- BigQuery API - bigquery.googleapis.com
- Cloud Pub/Sub API - pubsub.googleapis.com

## Install

### Terraform
Be sure you have the correct Terraform version (0.12.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/
