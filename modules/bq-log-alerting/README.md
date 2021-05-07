# Log Export: BigQuery Log Alerting

This submodule allows you to configure a BigQuery Log Alerting tool on Google Cloud Platform. It uses the log export created in the root module to create findings in the [Security Command Center](https://cloud.google.com/security-command-center) under a source called "BQ Log Alerts" based on rules defined as views in BigQuery.

This tool **does not** intend to provide an exhaustive and complete security solution, but rather helps you to have **insights** about events in your infrastructure and what can be monitored using Cloud Logging, BigQuery and Security Command Center.

## Basic Architecture

The overview of this tool is as follows:

- [Log sinks](https://github.com/terraform-google-modules/terraform-google-log-export) sends all [Cloud Audit Logs](https://cloud.google.com/logging/docs/audit) and [VPC Flow Logs](https://cloud.google.com/vpc/docs/flow-logs) to [BigQuery](https://github.com/terraform-google-modules/terraform-google-log-export/tree/master/modules/bigquery) located in a centralized logging project.
- Custom views in BigQuery are created that look for specific activities in these logs, defined by a SQL query, e.g. looking for events that match `v1.compute.routes.insert` or `v1.compute.routes.delete`.
- On a regular interval (`job_schedule` variable , default 15 minutes), [Cloud Scheduler](https://cloud.google.com/scheduler/docs) writes a message containing a time window parameter (`time_window_quantity` and `time_window_unit` variables, default 20 minutes) to [Cloud Pub/Sub](https://cloud.google.com/pubsub).
- This 15 minute schedule with 20 minute window is used to ensure some overlap between runs of the function, to catch cases where events may occur just as the [Cloud Function](https://cloud.google.com/functions) run has kicked-off.
- The message posted in Cloud Pub/Sub acts as the trigger for the Cloud Function which reads from the views that exist (one for each use case) and writes any events it finds to Security Command Center.
These events are called "findings" in Security Command Center parlance and represent events that are actionable, e.g. you can close them after investigation.
- Any duplicate findings are ignored, as the unique ID for the finding (a MD5 hash calculated from the concatenation of the BigQuery view name, the eventTimestamp, the callerIp, the principalEmail and the resourceName) is generated describing a particular event, and is thus deterministic.

This represents the overall flow of alerts in this tool.

**Note:** If you want to change the Cloud Scheduler [cron job interval](https://cloud.google.com/scheduler/docs/configuring/cron-job-schedules) (`job_schedule`) and the time window parameters (`time_window_quantity` and `time_window_unit`) make sure to to have some **overlap between runs of the function** so that there is no gap where log entries could be ignored.

### Cloud Logging and BigQuery

Before using this submodule it is necessary to use the [root module](https://github.com/terraform-google-modules/terraform-google-log-export) to create a log export and the [BigQuery submodule](https://github.com/terraform-google-modules/terraform-google-log-export/tree/master/modules/bigquery) to create a destination for the logs.

The log export filter must have at least the logs listed in the [Configure a Log Export](./README.md#configure-a-log-export) requirements section of this README to be used by the Log Alerting tool.

### Security Command Center

Security Command Center is an organization level tool that creates a single pane of glass interface for all security findings in your Google Cloud Platform projects.

Custom findings, based on events, can be configured for a variety of sources and can be [exported](https://cloud.google.com/security-command-center/docs/how-to-notifications) to other tools or notification systems for follow-up, triage, and investigation.
For this project, we make use of a custom source for all findings.

To create this source we need to grant the organization level Security Command Center role "Security Center Sources Editor" (`roles/securitycenter.sourcesEditor`) to the Terraform service account.

Findings can be filtered based on "category", which corresponds to the particular use case for the alert.
In order to create findings, we grant the BigQuery Log Alerting Cloud Function service account the "Security Center Findings Editor" role (`roles/securitycenter.findingsEditor`).

**Note:** Security Command Center sources can only be created with a service account and
for this to work, the Security Command Center API needs to be enabled in the Terraform admin project.

## Usage

The [examples](../../examples) directory contain a directory with an example for deploying the BigQuery Log Alerting tool.

Basic usage of this submodule is as follows:

```hcl
module "bq-log-alerting" {
  source            = "terraform-google-modules/log-export/google//modules/bq-log-alerting"
  logging_project   = <LOGGING_PROJECT>
  bigquery_location = <BIGQUERY_LOCATION>
  function_region   = <CLOUD_FUNCTION_REGION>
  org_id            = <ORG_ID>
  dry_run           = false
}
```

After the deploy of the submodule you will need to add some [Use cases](./use-cases/README.md) to provide the data for the Security Command Center findings.

**Note 1:** On deployment, a Security Command Center Source called "BQ Log Alerts" will be created. If this source already exist due to the tool been deployed at least once before in the organization, obtain the existing Source name to be used in the Terraform variable **source_name**. Run:

```shell
gcloud scc sources describe <ORG_ID> \
--source-display-name="BQ Log Alerts" \
--format="value(name)" \
--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>
```

The **source_name** format is `organizations/<ORG_ID>/sources/<SOURCE_ID>`.

**Note 2:** The submodule has a **dry_run** optional mode (`dry_run = true`). In this mode, instead of creating the finding in Security Command Center the submodule writes the finding to Cloud Logging. You can use the filter `resource.labels.function_name="generate-alerts" AND "DRY_RUN: scc finding:"` in the [Logs Explorer](https://console.cloud.google.com/logs/viewer) to find the logs created.

## Monitoring

You can [monitor the execution of the Cloud Function](https://cloud.google.com/functions/docs/monitoring) execution using:

- Google [Error Reporting](https://cloud.google.com/error-reporting/docs) and checking errors in the [Error Reporting dashboard](https://cloud.google.com/error-reporting/docs/viewing-errors)
- Google [Monitoring](https://cloud.google.com/monitoring/docs) adding a graph based in [Cloud Functions metrics](https://cloud.google.com/monitoring/api/metrics_gcp#gcp-cloudfunctions) for `function/execution_count` to your dashboard
- Google [Cloud Logging](https://cloud.google.com/logging/docs):
  - Filtering and exploring logs in the [Log Explorer](https://cloud.google.com/logging/docs/view/logs-viewer-interface) with query `resource.labels.function_name="generate-alerts"`
  - Creating a counter [User-defined metric](https://cloud.google.com/logging/docs/logs-based-metrics) to be used in a Cloud Monitoring dashboard with filter: `resource.labels.function_name="generate-alerts" AND severity>=ERROR`

### Budget Alerts

We recommend configuring a [billing budget](https://cloud.google.com/billing/docs/how-to/budgets) in the logging project to monitor and alert on the spending of the tool.

## Requirements

The following sections describe the requirements which must be met in
order to invoke this submodule.

### Configure a Log Export

- You need an existing "logging" project.
- You need A [Log export with a BigQuery destination](../../examples/bigquery/organization) created in the logging project.
The minimal filter in the log export module is:

```
"logName: /logs/cloudaudit.googleapis.com%2Factivity OR logName: /logs/cloudaudit.googleapis.com%2Fdata_access OR logName: /logs/compute.googleapis.com%2Fvpc_flows"
```

### Configure a Service Account

In order to execute this submodule you must have a Service Account with the following IAM Roles:

#### Project level Roles

- BigQuery Data Owner: `roles/bigquery.dataOwner`
- Cloud Functions Developer: `roles/cloudfunctions.developer`
- Cloud Scheduler Admin: `roles/cloudscheduler.admin`
- Pub/Sub Admin: `roles/pubsub.admin`
- Service Account Admin: `roles/iam.serviceAccountAdmin`
- Service Account User: `roles/iam.serviceAccountUser`
- Storage Admin: `roles/storage.admin`

#### Organization level Roles

- Security Admin: `roles/iam.securityAdmin`
- Security Center Sources Editor: `roles/securitycenter.sourcesEditor`

#### Impersonate the Service Account

Grant the following IAM roles [on the service account](https://cloud.google.com/iam/docs/impersonating-service-accounts#impersonate-sa-level) to the user deploying this submodule:

- Service Account User: `roles/iam.serviceAccountUser`
- Service Account Token Creator: `roles/iam.serviceAccountTokenCreator`

### Enable APIs

The project against which this submodule will be invoked must have the
following APIs enabled:

- App Engine Admin API: `appengine.googleapis.com`
- BigQuery API: `bigquery.googleapis.com`
- Cloud Build API: `cloudbuild.googleapis.com`
- Cloud Functions API: `cloudfunctions.googleapis.com`
- Cloud Logging API: `logging.googleapis.com`
- Cloud Pub/Sub API: `pubsub.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`
- Cloud Scheduler API: `cloudscheduler.googleapis.com`
- Cloud Storage API: `storage-component.googleapis.com`
- Identity and Access Management (IAM) API: `iam.googleapis.com`
- Security Command Center API: `securitycenter.googleapis.com`

### Enable Google App Engine

[Google App Engine](https://cloud.google.com/appengine) must be enabled in the logging project. To enable it manually use:

```shell
gcloud app create \
--region=<GAE_LOCATION> \
--project=<LOGGING_PROJECT>
```

**Note:** The selected [Google App Engine location](https://cloud.google.com/appengine/docs/locations) cannot be changed after creation and only project Owners (`role/owner`) can enable Google App Engine. If you are not an Owner of the project, but the service account is, you can add `--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>` to the command like it was used when the Security Command Center source was created.

### Terraform plugins

- [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin ~> v3.5.x

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bigquery\_location | Location for BigQuery resources. See https://cloud.google.com/bigquery/docs/locations for valid values. | `string` | `"US"` | no |
| dry\_run | Enable dry\_run execution of the Cloud Function. If is true it will just print the object the would be converted as a finding | `bool` | `false` | no |
| function\_memory | The amount of memory in megabytes allotted for the Cloud function to use. | `number` | `"256"` | no |
| function\_region | Region for the Cloud function resources. See https://cloud.google.com/functions/docs/locations for valid values. | `string` | n/a | yes |
| function\_timeout | The amount of time in seconds allotted for the execution of the function. | `number` | `"540"` | no |
| job\_schedule | The schedule on which the job will be executed in the unix-cron string format (https://cloud.google.com/scheduler/docs/configuring/cron-job-schedules#defining_the_job_schedule). Defaults to 15 minutes. | `string` | `"*/15 * * * *"` | no |
| logging\_project | The project to deploy the tool. | `string` | n/a | yes |
| org\_id | The organization ID for the associated services | `string` | n/a | yes |
| source\_name | The Security Command Center Source name for the "BQ Log Alerts" Source if the source had been created before. The format is `organizations/<ORG_ID>/sources/<SOURCE_ID>` | `string` | `""` | no |
| time\_window\_quantity | The time window quantity used in the query in the view in BigQuery. | `string` | `"20"` | no |
| time\_window\_unit | The time window unit used in the query in the view in BigQuery. Valid values are 'MICROSECOND', 'MILLISECOND', 'SECOND', 'MINUTE', 'HOUR' | `string` | `"MINUTE"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bq\_views\_dataset\_id | The ID of the BigQuery Views dataset |
| cloud\_function\_service\_account\_email | The email of the service account created to be used by the Cloud Function |
| cloud\_scheduler\_job | The Cloud Scheduler job instance |
| cloud\_scheduler\_job\_name | The name of the Cloud Scheduler job created |
| pubsub\_topic\_name | Pub/Sub topic name |
| source\_name | The Security Command Center Source name for the "BQ Log Alerts" Source |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
