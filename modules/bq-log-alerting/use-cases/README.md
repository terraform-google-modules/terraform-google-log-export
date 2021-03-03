# Use Cases

After installing the BigQuery Log Alerting tool, you will need to add some use cases to see it working.
We provided a few examples in this submodule, with some queries that can be use to populate Security Command Center with findings.

## Prerequisites

1. BigQuery Log Alerting tool installed.
1. BigQuery log sinks created.
1. Tables created by the sinks logs exported ( e.g.: `cloudaudit_googleapis_com_activity_*`)
1. To have permission to create BigQuery views in the logging project.

## General Usage

In this folder you will find several SQL files, you must change the variables `${project}`and `${dataset}` in each file
to the real logging project ID and log sink dataset name created in the BigQuery log sinks deploy.
Follow the specific usage of **each use case** for more details.

After this, you can follow the instruction of [How create Views in BigQuery](https://cloud.google.com/bigquery/docs/views#console) using the queries on the files.

You **must** save the views on the `views` dataset for the tool to work.
You can use the filename as the view name, if you want.
The view name will be used for the **category** of the finding that will be created.

## Use Case descriptions

### Services not on Allow List

- Query File: `non_allowlisted_services.sql`
- Query Table used: `cloudaudit_googleapis_com_activity_*`
- Description: This use case aims to alert when a service outside of the accepted list of services is enabled for a project. This list is hardcoded in the query. The current list is:
  - dns.googleapis.com
  - iap.googleapis.com
  - compute.googleapis.com
  - file.googleapis.com
  - stackdriver.googleapis.com
- Usage: If you want modify the list of services just change the line `dns.googleapis.com|iap.googleapis.com|compute.googleapis.com|file.googleapis.com|stackdriver.googleapis.com` adding or removing the services. Examples:

  - To add the service `translate.googleapis.com` just add `|translate.googleapis.com` in the line so the end result be like `dns.googleapis.com|iap.googleapis.com|compute.googleapis.com|file.googleapis.com|stackdriver.googleapis.com|translate.googleapis.com`
  - To remove the service `file.googleapis.com` just remove `|file.googleapis.com` from the line so the end result be like `dns.googleapis.com|iap.googleapis.com|compute.googleapis.com|stackdriver.googleapis.com`

- Testing: Just enable a service that is not present in the list like `translate.googleapis.com`. You can enable a service running the following command:

```bash
export project_id=<Any project that sends its audit logs go to the sink>
gcloud services enable \
translate.googleapis.com \
--project ${project_id}
```

### IAM Policy granted on User Outside of Customer Approved Domain List

- Query File: `iam_role_add.sql`
- Query Table used: `cloudaudit_googleapis_com_activity_*`
- Description: This use case alerts on any IAM role being granted on a user with a domain outside of an approved list. The approved domain list is hardcoded within the view query like `%domain1.com%` and `%domain2.com%`.
- Usage: Change the values `%domain1.com%` and `%domain2.com%` with your respective domains like `%yourrealdomain1.com%` and `%yourrealdomain2.com%`.
- Testing: Grant a permission to a user outside your domains in GCP console or using gcloud commands like:

```bash
gcloud projects add-iam-policy-binding <PROJECT_ID> \
--member=user:<USER>@gmail.com \
--role=roles/gameservices.viewer
```

### Alert on Changes to Logging

- Query File: `logging_changes.sql`
- Query Table used: `cloudaudit_googleapis_com_activity_*`
- Description: This use case aims to detect any modifications made to logging within a project. This includes creating or deleting log sinks, or deleting logs themselves. This does not include modifications to VPC flow logs.
- Usage: The query doesn't need changes besides the ones described in section [General Usage](./README.md#general-usage) .
- Testing: There are some ways to generate logs:
  - Create a log sink
  - Delete log sink
  - Attempt to delete audit logs
  - Delete logs
  - Write entry to log file
  - Create logs based metric
  - Delete logs based metric

### Alert on VPC Flow Logs being disabled

- Query File: `disable_vpc_flow_logs.sql`
- Query Table used: `cloudaudit_googleapis_com_activity_*`
- Description: This use case creates an alert when VPC flow logs for a particular subnet are disabled. It looks for modifications to the `gce_subnetwork` resource type where `enableFlowLogs = False`.
- Usage: The query doesn't need changes besides the ones described in section [General Usage](./README.md#general-usage).
- Testing: Go to GCP console, select a subnetwork and edit its **Flow logs** option to **off**

### Add or Remove Routes

- Query File: `add_remove_routes.sql`
- Query Table used: `cloudaudit_googleapis_com_activity_*`
- Description: This use case creates an alert when a GCE Route is created or deleted.
- Usage: The query doesn't need changes besides the ones described in section [General Usage](./README.md#general-usage).
- Testing: Go to GCP console and create or delete a GCE Route.

### VPC Flow logs with ingress from IP Addresses outside of expected private address ranges

- Query File: `ingress_from_external_ip.sql`
- Query Table used: `compute_googleapis_com_vpc_flows_*`
- Description: This use case examines the VPC flow logs for all source projects and looks for ingress from IPs outside of known good IP ranges, such as on premise IPs or Google Cloud IPs. Those IP ranges are hardcoded in the query.
- Usage: To look for a new IP ranges just add a new `OR` clause in the query like: `OR NET.IP_TRUNC(src_ip_parsed, NETMASK) = b"\xDD\xDD\xDD\xDD"` where `NETMASK` is the value of the netmask and `\xDD\xDD\xDD\xDD"` is the IP range in hexadecimal format. Make sure to substitute correctly the `DD` to hexadecimal values and to maintain the `\xDD` format.
- Testing: First make sure that VPC Flow logs are enabled. If already have a gce instance, its communication to google address will produce the logs.

### Abnormal amount of data movement out of the cloud

- Query File: `bytes_sent.sql`
- Query Table used: `compute_googleapis_com_vpc_flows_*`
- Description: This use case creates an alert when a VM sends an amount of data beyond a specific threshold to an unknown, or untrusted IP address. This is done by examining the bytes sent field of the VPC flow logs, summing over the amount of data sent between a pair of particular IPs. Those IP ranges are hardcoded in the query as well as the data threshold.
- Usage: To look for a new range of IPs just add a new `OR` clause in the query like: `OR NET.IP_TRUNC(NET.SAFE_IP_FROM_STRING(jsonPayload.connection.dest_ip),NETMASK) = b"\xDD\xDD\xDD\xDD"` where `NETMASK` is the value of the netmask and `\xDD\xDD\xDD\xDD"` is the IP range in hexadecimal format. Make sure to substitute correctly the `DD` to hexadecimal values and to maintain the `\xDD` format. To change the data threshold just change the `ẀHERE bytes_sent > 1E9;` clause with a new value
- Testing: First make sure that VPC Flow logs are enabled. If you already have a VM instance you can reduce the data threshold to see the logs.

### Anomalous Privileged Terraform Service Account Usage

- Query File: `anomalous_terraform_sa_usage.sql`
- Query Table used: `cloudaudit_googleapis_com_activity_*`
- Description: This use case creates an alert for anomalous usage of a privileged service account that is used by a CI/CD work flow to deploy the infrastructure using terraform.
Anomalous usage is the use of the terraform service account by someone that is not the CI/CD service account. See [Terraform Example Foundation](https://github.com/terraform-google-modules/terraform-example-foundation) for [Google Cloud Build](https://cloud.google.com/cloud-build) or Jenkins examples of CI/CD to deploy infrastructure.
- Usage: Change the values of `<TERRAFORM_SERVICE_ACCOUNT_EMAIL>` and `<CICD_SERVICE_ACCOUNT_EMAIL>`:
  - `<TERRAFORM_SERVICE_ACCOUNT_EMAIL>`: The email of the Service account that has been granted the permissions to deploy infrastructure . For example, if you are using [Terraform Google Bootstrap module](https://github.com/terraform-google-modules/terraform-google-bootstrap) the service account email is the `terraform_sa_email`.
  - `<CICD_SERVICE_ACCOUNT_EMAIL>`:
    - If you are using Cloud build the CI/CD service account email is the Cloud Build service account `<cloud-build-project-number>@cloudbuild.gserviceaccount.com`.
    - If you are using Jenkins the CI/CD service account email is the service account created to be used by the Jenkins agent.
- Testing: Run a gcloud `list` or `describe` command on a resource under the monitoring of the sink created to export logs to BigQuery using [service account impersonation](https://cloud.google.com/sdk/gcloud/reference#--impersonate-service-account)`--impersonate-service-account=<TERRAFORM_SERVICE_ACCOUNT_EMAIL>`.

### Alert on Super Admin (Org./Owner) Login

**NOTE:** This use case needs configurations on **organization level**.

- Query File: `superadmin_login.sql`
- Query Table used: `cloudaudit_googleapis_com_data_access_*`
- Description: This use case creates an alert for a variety of login events including success, failure, suspicious login, and login verification required, for super administrator accounts. While the current implementation includes a list of email addresses to be monitored, it can be assumed that all logins represent an event, since only super admin accounts are verified through Cloud Identity.
- Usage: Change the values of `<user1>@<domain>` and `<user2>@<domain>` with the users that you want to monitor.
- Testing: First make sure that you enabled the [Admin audit log](https://support.google.com/a/answer/9320190?hl=en) to export logs to GCP. If you created the [Log Export](https://github.com/terraform-google-modules/terraform-google-log-export) at the organization level, you just need to login to generate an alert. If you create the Log Export at folder or project level then you will need to create a new log sink:

Create a new sink on the organization to catch the `data_access` logs:

```bash
  export project_id=<PROJECT_ID>
  export organization_id=<ORGANIZATION_ID>
  export sink_name='sk-c-logging-admin-bq'
  gcloud logging sinks create ${sink_name} bigquery.googleapis.com/projects/${project_id}/datasets/audit_logs \
  --log-filter="logName: /logs/cloudaudit.googleapis.com%2Fdata_access"
  --organization=${organization_id}
```

where `project_id` is the project ID used to deploy the submodule.
