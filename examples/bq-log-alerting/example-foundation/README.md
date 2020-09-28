# Example: BigQuery Log Alerting solution

This example deploys the BigQuery Log Alerting submodule in an existing project.

## Prerequisites

To run this example, you'll need:

- An existing "logging" project
- A [Log export](https://github.com/terraform-google-modules/terraform-google-log-export) with a [BigQuery destination](https://github.com/terraform-google-modules/terraform-google-log-export/tree/master/modules/bigquery) in the logging project. The export filter should include at least:
  - "logName: /logs/cloudaudit.googleapis.com%2Factivity"
  - "logName: /logs/cloudaudit.googleapis.com%2Fdata_access"
  - "logName: /logs/compute.googleapis.com%2Fvpc_flows"
- A Terraform Service Account with the [IAM Roles](../../../modules/bq-log-alerting/README.md) listed in the module documentation.
- To enable the [APIs](../../../modules/bq-log-alerting/README.md) listed in the module documentation in the logging project.
- To enable [Google App Engine](https://cloud.google.com/appengine) in the logging project.
To enable it manually use:

```shell
gcloud app create \
--region=<REGION> \
--project=<LOGGING_PROJECT> \
--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

**Note 1:** The selected Google App Engine region cannot be changed after creation.

**Note 2:** On deployment a Security Command Center Source called "BQ Log Alerts" will be created. If this source already exist due to the solution been deployed at least once before,  obtain the existing Source name to be used in the terraform variable **source_name**. Run:

```shell
gcloud scc sources describe <ORG_ID> \
--source-display-name="BQ Log Alerts" \
--format="value(name)" \
--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

The [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation) can be used as a reference for the creation of the project, service account and log export.

## Instructions

1. Run `terraform init`
1. Run `terraform plan` provide the requested variables values and review the output.
1. Run `terraform apply`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to a service account credentials file with rights to run Terraform. Service Account must have the roles listed in the Requirements section of the README file. | string | n/a | yes |
| dry\_run | Enable dry_run execution of the Cloud Function. If is true it will just print the object the would be converted as a finding | bool | `"false"` | no |
| logging\_project | The project to deploy the solution | string | n/a | yes |
| org\_id | The organization id for the associated services | string | n/a | yes |
| region | Region for BigQuery resources. | string | n/a | yes |
| source\_name | The Security Command Center Source name for the "BQ Log Alerts" Source if the source had been created before. The format is `organizations/<ORG_ID>/sources/<SOURCE_ID>` | string | `""` | no |

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
