# Example: BigQuery Log Alerting

This example deploys the BigQuery Log Alerting submodule in an existing project.

## Prerequisites

To run this example, you'll need:

- An existing "logging" project
- A [Log export](https://github.com/terraform-google-modules/terraform-google-log-export) with a [BigQuery destination](https://github.com/terraform-google-modules/terraform-google-log-export/tree/master/modules/bigquery) created in the logging project. The export filter should include at least:
  - "logName: /logs/cloudaudit.googleapis.com%2Factivity"
  - "logName: /logs/cloudaudit.googleapis.com%2Fdata_access"
  - "logName: /logs/compute.googleapis.com%2Fvpc_flows"
- A Terraform Service Account with the [IAM Roles](../../modules/bq-log-alerting/README.md#iam-roles) listed in the submodule documentation.
- To enable in the logging project the [APIs](../../modules/bq-log-alerting/README.md#apis) listed in the submodule documentation.
- To enable in the logging project [Google App Engine](https://cloud.google.com/appengine).
To enable it manually use:

```shell
gcloud app create \
--region=<GAE_LOCATION> \
--project=<LOGGING_PROJECT>
```

**Note 1:** The selected [Google App Engine location](https://cloud.google.com/appengine/docs/locations) cannot be changed after creation and only project Owners (`role/owner`) can enable Google App Engine.

**Note 2:** On deployment a Security Command Center Source called "BQ Log Alerts" will be created. If this source already exist due to the submodule been deployed at least once before, you need to obtain the existing Source name to be informed in the terraform variable **source_name**.
Run:

```shell
gcloud scc sources describe <ORG_ID> \
--source-display-name="BQ Log Alerts" \
--format="value(name)" \
--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

The source name format is `organizations/<ORG_ID>/sources/<SOURCE_ID>`.

The [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation) can be used as a reference for the creation of the logging project, the service account and the log export.

## Instructions

1. Run `terraform init`
1. Run `terraform plan` provide the requested variables values and review the output.
1. Run `terraform apply`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bigquery\_location | Location for BigQuery resources. See https://cloud.google.com/bigquery/docs/locations for valid values. | `string` | `"US"` | no |
| function\_region | Region for the Cloud function resources. See https://cloud.google.com/functions/docs/locations for valid values. | `string` | n/a | yes |
| logging\_project | The project to deploy the submodule | `string` | n/a | yes |
| org\_id | The organization ID for the associated services | `string` | n/a | yes |
| source\_name | The Security Command Center Source name for the "BQ Log Alerts" Source if the source had been created before. The format is `organizations/<ORG_ID>/sources/<SOURCE_ID>` | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| bq\_views\_dataset\_id | The ID of the BigQuery Views dataset |
| cloud\_function\_service\_account\_email | The email of the service account created to be used by the cloud function |
| cloud\_scheduler\_job | The Cloud Scheduler job instance |
| cloud\_scheduler\_job\_name | The name of the Cloud Scheduler job created |
| pubsub\_topic\_name | PubSub topic name |
| source\_name | The Security Command Center Source name for the "BQ Log Alerts" Source |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
