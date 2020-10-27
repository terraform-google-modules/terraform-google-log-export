# Log Export: BigQuery Log Alerting

This submodule allows you to configure a BigQuery Log Alerting solution on GCP. It uses the log export created in the root module to create findings in the [Security Command Center](https://cloud.google.com/security-command-center) under a source called "BQ Log Alerts" based on rules defined as views in BigQuery.

## Basic Architecture

### Cloud Logging

The overview of this solution is as follows. [Log sinks](https://github.com/terraform-google-modules/terraform-google-log-export) sends all Cloud Audit Logs and VPC Flow Logs to [BigQuery](https://github.com/terraform-google-modules/terraform-google-log-export/tree/master/modules/bigquery) located in a centralized logging project.
Custom views in BigQuery are created that look for specific activities in these logs, defined by a SQL query, e.g. looking for events that match `v1.compute.routes.insert` or `v1.compute.routes.delete`.
On a regular interval (`job_schedule` variable , default 15 minutes), Cloud Scheduler writes a message containing a time window parameter (`time_window_quantity` and `time_window_quantity` variables, default 20 minutes) to PubSub.
This 15 minute schedule with 20 minute window is used to ensure some overlap between runs of the function, to catch cases where events may occur just as the Cloud Function run has kicked-off.
The message in PubSub acts as the trigger for the Google Cloud Function (GCF) which reads from the views that exist (one for each use case) and writes any events it finds to Cloud Security Command Center (CSCC).
These events are called "findings" in CSCC parlance and represent events that are actionable, e.g. can close them after investigation.
Any duplicate findings are ignored, as the unique ID for the finding (a MD5 hash calculated from the concatenation of the bq view name, the eventTimestamp, the callerIp, the principalEmail and the resourceName) is generated describing a particular event, and is thus repeatable.
This represents the overall flow of alerts in this solution.

**Note:** If you want to change the Cloud Scheduler interval and the time window parameter make sure to ensure some overlap between runs of the function.

### Security Command Center

Cloud Security Command Center is an organization level tool that creates a single pane of glass interface for all security findings in your GCP projects.
Custom findings, based on events, can be configured for a variety of sources and can be [exported](https://cloud.google.com/security-command-center/docs/how-to-notifications) to other tools or notification systems for follow-up, triage, and investigation.
For this project, we make use of a custom source for all findings.
Findings can be filtered based on "category", which corresponds to the particular use case for the alert.
To create this source we need to grant org. level security command center permissions to the Terraform service account (`roles/securitycenter.sourcesEditor`).
In order to create findings, we grant the alerting cloud function service account `roles/securitycenter.findingsEditor`.

**Note:** Security Command Center sources can only be created with a service account and
for this to function, the security center API needs to be enabled in the Terraform admin project.

## Usage

Basic usage of this module is as follows:

```hcl
module "bq-log-alerting" {
  source          = "terraform-google-modules/log-export/google//modules/bq-log-alerting"
  logging_project = <LOGGING_PROJECT>
  region          = <REGION>
  org_id          = <ORG_ID>
  dry_run         = false
}
```

The [examples](../../examples) directory contain an example for deploying the BigQuery Log Alerting solution.

**Note 1:** On deployment, a Security Command Center Source called "BQ Log Alerts" will be created. If this source already exist due to the solution been deployed at least once before in the organization, obtain the existing Source name to be used in the terraform variable **source_name**. Run:

```shell
gcloud scc sources describe <ORG_ID> \
--source-display-name="BQ Log Alerts" \
--format="value(name)" \
--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

The **source_name** format is `organizations/<ORG_ID>/sources/<SOURCE_ID>`.

**Note 2:** The module has a **dry_run** optional mode (`dry_run = true`). In this mode, instead of creating the finding in Security Command Center the module writes the finding to Google logging.

## Requirements

The following sections describe the requirements which must be met in
order to invoke this module.

### General

* You need an existing "logging" project.
* A [Log export](https://github.com/terraform-google-modules/terraform-google-log-export) with a [BigQuery destination](https://github.com/terraform-google-modules/terraform-google-log-export/tree/master/modules/bigquery) in the logging project. The export filter should include at least:
  * "logName: /logs/cloudaudit.googleapis.com%2Factivity"
  * "logName: /logs/cloudaudit.googleapis.com%2Fdata_access"
  * "logName: /logs/compute.googleapis.com%2Fvpc_flows"
* It is necessary to use a Service Account to authenticate the Google Terraform provider to be able to create the Security Command Center "BQ Log Alerts" Source.
This is a restriction of the Security Command Center API
* [Google App Engine](https://cloud.google.com/appengine) must be enabled in the logging project. To enable it manually use:

```shell
gcloud app create \
--region=<REGION> \
--project=<LOGGING_PROJECT> \
--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

**Note:** The selected region cannot be changed after creation.

### IAM Roles

The Service Account which will be used to invoke this module must have the following IAM roles:

* Project level:
  * Cloud Functions Developer: `roles/cloudfunctions.developer`
  * Storage Admin: `roles/storage.admin`
  * Pub/Sub Admin: `roles/pubsub.admin`
  * Service Account User: `roles/iam.serviceAccountUser`
* Organization level
  * Security Center Sources Editor: `roles/securitycenter.sourcesEditor`
  * Security Admin: `roles/iam.securityAdmin`

If you are deploying this module in the logging project of the Terraform Example Foundation using the Terraform Service account created in the Foundation, it already has all the necessary permissions in the logging project.

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

* App Engine Admin API: `appengine.googleapis.com`
* BigQuery API: `bigquery.googleapis.com`
* Cloud Build API: `cloudbuild.googleapis.com`
* Cloud Functions API: `cloudfunctions.googleapis.com`
* Cloud Logging API: `logging.googleapis.com`
* Cloud Pub/Sub API: `pubsub.googleapis.com`
* Cloud Scheduler API: `cloudscheduler.googleapis.com`
* Cloud Storage API: `storage-component.googleapis.com`
* Security Command Center API: `securitycenter.googleapis.com`

### Software Dependencies

* [Terraform][terraform-site] v0.12
* [Terraform Provider for Google Cloud Platform][terraform-provider-gcp-site] v3.25.0

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dry\_run | Enable dry_run execution of the Cloud Function. If is true it will just print the object the would be converted as a finding | bool | `"false"` | no |
| function\_memory | The amount of memory in megabytes allotted for the Cloud function to use. | number | `"256"` | no |
| function\_timeout | The amount of time in seconds allotted for the execution of the function. | number | `"540"` | no |
| job\_schedule | The schedule on which the job will be executed in the unix-cron string format (https://cloud.google.com/scheduler/docs/configuring/cron-job-schedules#defining_the_job_schedule). Defaults to 15 minutes. | string | `"*/15 * * * *"` | no |
| logging\_project | The project to deploy the solution | string | n/a | yes |
| org\_id | The organization id for the associated services | string | n/a | yes |
| region | Region for BigQuery resources. | string | n/a | yes |
| source\_name | The Security Command Center Source name for the "BQ Log Alerts" Source if the source had been created before. The format is `organizations/<ORG_ID>/sources/<SOURCE_ID>` | string | `""` | no |
| time\_window\_quantity | The time window quantity used in the query in the view in BigQuery. | string | `"20"` | no |
| time\_window\_unit | The time window unit used in the query in the view in BigQuery. Valid values are 'MICROSECOND', 'MILLISECOND', 'SECOND', 'MINUTE', 'HOUR' | string | `"MINUTE"` | no |

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
