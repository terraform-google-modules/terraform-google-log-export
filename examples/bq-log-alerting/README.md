# Example: BigQuery Log Alerting

This example deploys the BigQuery Log Alerting submodule in an existing project.

## Requirements

Make sure you have the requirements listed in the submodule [README](../../modules/bq-log-alerting/README.md) Before running this example.

## Instructions

### Check if the Source "BQ Log Alerts" exist

On deployment a Security Command Center Source called "BQ Log Alerts" will be created.
If this source already exist due to the submodule been deployed at least once before,
you need to obtain the existing Source name to be informed in the terraform variable **source_name**.
Run:

```shell
gcloud scc sources describe <ORG_ID> \
--source-display-name="BQ Log Alerts" \
--format="value(name)" \
--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

The source name format is `organizations/<ORG_ID>/sources/<SOURCE_ID>`.

### Activate impersonation of the service account

To activate impersonation on the service account you can:

Set the `gcloud` config auth impersonation:

```shell
gcloud config set auth/impersonate_service_account <TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

Or

Change the [versions.tf](./versions.tf) file to set [impersonation on the provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#impersonate_service_account):

From

```terraform
provider "google" {
  version = "~> 3.53.0"
}

```

To

```terraform
provider "google" {
  version = "~> 3.53.0"

  impersonate_service_account = "<TERRAFORM_SERVICE_ACCOUNT_EMAIL>"
}

```

### Run Terraform

1. Run `terraform init`
1. Run `terraform plan` provide the requested variables values and review the output.
1. Run `terraform apply`

### Deploy Use Cases

Deploy the [Use Cases](../../modules/bq-log-alerting/use-cases) that will provide the data for the Security Command Center findings.

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
