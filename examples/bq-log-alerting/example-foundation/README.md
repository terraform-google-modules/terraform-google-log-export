# Example: Deploy BigQuery Log Alerting solution in terraform-example-foundation

The solution deploys the BigQuery Log Alerting submodule in the logging project created in step `1 org` of the [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation).

## Prerequisites

To run this example, you'll need:

- To deploy the terraform-example-foundation up to step `1-org`.
- To use the Terraform Service Account and the Terraform state bucket created in the terraform-example-foundation step `0-bootstrap`.
- To enable [Google App Engine](https://cloud.google.com/appengine) in the terraform-example-foundation logging project.
To enable it manually use:

```shell
gcloud app create \
--region=<DEFAULT_REGION> \
--project=<LOGGING_PROJECT> \
--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

**Note:** The selected Google App Engine region cannot be changed after creation.

**Note:** On deployment a Security Command Center Source called "BQ Log Alerts" will be created. If this source already exist due to the solution been deployed at least once before, run `gcloud scc sources describe <ORG_ID> --source-display-name="BQ Log Alerts"  --format="value(name)" --impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>` to obtain the Source name to be used for the terraform variable **source_name**.

## Instructions

1. Fill the required variables in the `terraform.tfvars.sample` file located in this directory and rename the file to `terraform.tfvars`.
1. Run the Terraform automation:
   1. Run `terraform init`
   1. Run `terraform plan` and review output.
   1. Run `terraform apply`
1. Rename file `backend.tf.sample` to `backend.tf` and update `backend.tf` with the terraform-example-foundation Terraform state GCS bucket.
1. Re-run `terraform init` and agree to copy state to GCS when prompted
    1. (Optional) Run `terraform apply` to verify state is configured correctly

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dry\_run | Enable dry_run execution of the Cloud Function. If is true it will just print the object the would be converted as a finding | bool | `"false"` | no |
| logging\_project | The project to deploy the solution | string | n/a | yes |
| org\_id | The organization id for the associated services | string | n/a | yes |
| region | Region for BigQuery resources. | string | n/a | yes |
| source\_name | The Security Command Center Source name for the "BQ Log Alerts" Source if the source had been created before. The format is `organizations/<ORG_ID>/sources/<SOURCE_ID>` | string | `""` | no |
| terraform\_service\_account | Service account email of the account to impersonate to run Terraform. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bq\_views\_dataset\_id | The ID of the BigQuery Views dataset |
| cloud\_function\_service\_account\_email | The email of the service account created to be used by the cloud function |
| name | The name of the job created |
| pubsub\_topic\_name | PubSub topic name |
| scheduler\_job | The Cloud Scheduler job instance |
| source\_name | The Security Command Center Source name for the "BQ Log Alerts" Source |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
