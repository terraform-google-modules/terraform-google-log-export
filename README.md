# Terraform Log Export Module

This module allows you to create log exports at the project, folder,
organization, or billing account level. Submodules are  available to
configure the destination resource that will store all exported logs. The
resources/services/activations/deletions that this module will create/trigger
are:

- An **Aggregated log export** on the project-level, folder-level, organization-level, or billing-account-level
- A **Service account** (logsink writer)
- A **Destination** (Cloud Storage bucket, Cloud Pub/Sub topic, BigQuery dataset)

## Usage

The [examples](./examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a Cloud Storage destination and a log export at the project level:

### BigQuery
To create log exports to BigQuery, use the `bigquery` submodule:

```hcl
module "bigquery_exports" {
  source                 = "./modules/terraform-google-log-export/modules/bigquery"
  parent_resource_id     = "432162980571"
  parent_resource_type   = "organization"
  destination_project_id = "rnm-cloud-foundation-testing"
  include_children       = "true"

  bigquery_dataset_names = [
    "rnm_test_bigquery_1",
    "rnm_test_bigquery_2",
  ]

  sink_names = [
    "test-sink-bigquery-1",
    "test-sink-bigquery-2",
  ]

  filters = [
    "organizations/465421231564/logs/cloudaudit.googleapis.com%2Factivity",
    "organizations/465421231564/logs/cloudaudit.googleapis.com%2Fsystem_event",
  ]
}
```

### Cloud Pub/Sub
To create log exports to Pub/Sub, use the `pubsub` submodule:

```hcl
module "pubsub_exports" {
  source                 = "./modules/terraform-google-log-export/modules/pubsub"
  parent_resource_id     = "430062980571"
  parent_resource_type   = "organization"
  destination_project_id = "rnm-cloud-foundation-testing"
  include_children       = "true"

  enable_splunk = "true"

  pubsub_topic_names = [
    "test-pubsub-1",
    "test-pubsub-2",
  ]

  sink_names = [
    "test-sink-pubsub-1",
    "test-sink-pubsub-2",
  ]

  filters = [
    "organizations/465421231564/logs/cloudaudit.googleapis.com%2Factivity",
    "organizations/465421231564/logs/cloudaudit.googleapis.com%2Fsystem_event",
  ]
}
```

### Cloud Storage
To create log exports to Cloud Storage, use the `storage` submodule:

```hcl
module "storage_exports" {
  source                 = "./modules/terraform-google-log-export/modules/storage"
  parent_resource_id     = "430062980571"
  parent_resource_type   = "organization"
  destination_project_id = "rnm-cloud-foundation-testing"
  include_children       = "true"

  storage_bucket_class              = "COLDLINE"
  storage_bucket_location           = "EU"
  storage_bucket_versioning_enabled = "true"

  storage_bucket_names = [
    "rnm_test_storage_3",
    "rnm_test_storage_4",
  ]

  sink_names = [
    "test-sink-storage-3",
    "test-sink-storage-4",
  ]

  filters = [
    "organizations/465421231564/logs/cloudaudit.googleapis.com%2Factivity",
    "organizations/465421231564/logs/cloudaudit.googleapis.com%2Fsystem_event",
  ]
}
```


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| destination\_uri | The self_link URI of the destination resource (This is available as an output coming from one of the destination submodules) | string | n/a | yes |
| filter | The filter to apply when exporting logs. Only log entries that match the filter are exported. Default is '' which exports all logs. | string | `""` | no |
| include\_children | Only valid if 'organization' or 'folder' is chosen as var.parent_resource.type. Determines whether or not to include children organizations/folders in the sink export. If true, logs associated with child projects are also exported; otherwise only logs relating to the provided organization/folder are included. | string | `"false"` | no |
| log\_sink\_name | The name of the log sink to be created. | string | n/a | yes |
| parent\_resource\_id | The ID of the GCP resource in which you create the log sink. If var.parent_resource_type is set to 'project', then this is the Project ID (and etc). | string | n/a | yes |
| parent\_resource\_type | The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing_account', or 'organization'. | string | `"project"` | no |
| unique\_writer\_identity | Whether or not to create a unique identity associated with this sink. If false (the default), then the writer_identity used is serviceAccount:cloud-logs@system.gserviceaccount.com. If true, then a unique service account is created and used for the logging sink. | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| filter | The filter to be applied when exporting logs. |
| log\_sink\_resource\_id | The resource ID of the log sink that was created. |
| log\_sink\_resource\_name | The resource name of the log sink that was created. |
| parent\_resource\_id | The ID of the GCP resource in which you create the log sink. |
| writer\_identity | The service account that logging uses to write log entries to the destination. |

[^]: (autogen_docs_end)

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.11.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin ~> v2.0.x

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


### Enable API's
In order to operate with the Service Account you must activate the following API's on the base project where the Service Account was created:

- Cloud Resource Manager API - cloudresourcemanager.googleapis.com
- Cloud Billing API - cloudbilling.googleapis.com
- Identity and Access Management API - iam.googleapis.com
- Service Usage API - serviceusage.googleapis.com
- Stackdriver Logging API - logging.googleapis.com
- Cloud Storage JSON API - storage-api.googleapis.com
- BigQuery API - bigquery-json.googleapis.com
- Cloud Pub/Sub API - pubsub.googleapis.com

## Install

### Terraform
Be sure you have the correct Terraform version (0.11.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

## Testing

### Requirements
- [bundler](https://github.com/bundler/bundler)
- [gcloud](https://cloud.google.com/sdk/install)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.6.0

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Integration test

Integration tests are run though [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform), and [InSpec](https://github.com/inspec/inspec).

`test-kitchen` instances are defined in [`.kitchen.yml`](./.kitchen.yml). The test-kitchen instances in `test/fixtures/` wrap identically-named examples in the `examples/` directory.

#### Setup

1. Configure the [test fixtures](#test-configuration)
2. Download a Service Account key with the necessary permissions and copy the contents of that JSON file into the `SERVICE_ACCOUNT_JSON` environment variable:

  ```
  export SERVICE_ACCOUNT_JSON=$(cat /path/to/credentials.json)
  ```

3. Set the required environment variables as defined in [`./test/ci_integration.sh`](./test/ci_integration.sh):

  ```
  export PROJECT_ID="project_id_of_test_project"
  export PARENT_RESOURCE_PROJECT="project_id_of_test_project"
  export PARENT_RESOURCE_FOLDER="folder_id_of_test_folder"
  export PARENT_RESOURCE_ORGANIZATION="org_id_of_test_organization"
  export PARENT_RESOURCE_BILLING_ACCOUNT="billing_account_id_of_test_billing_account"
  export SUITE="test_suite_name"  # Leave empty to run all tests
  ```

4. Run the testing container in interactive mode:

  ```
  make docker_run
  ```

  The module root directory will be loaded into the Docker container at `/cft/workdir/`.
5. Run kitchen-terraform to test the infrastructure:

  1. `make docker_create` creates Terraform state and downloads modules, if applicable.
  2. `make docker_converge` creates the underlying resources. Run `source test/ci_integration.sh && setup_environment && kitchen converge <INSTANCE_NAME>` to run a specific test case.
  3. `make docker_verify` tests the created infrastructure. Run `source test/ci_integration.sh && setup_environment && kitchen verify <INSTANCE_NAME>` to run a specific test case.
  4. `make docker_destroy` tears down the underlying resources created by `make docker_converge`. Run `source test/ci_integration.sh && setup_environment && kitchen destroy <INSTANCE_NAME>` to tear down resources for a specific test case.

Alternatively, you can simply run `make test_integration_docker` to run all the test steps non-interactively.

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Linting
The makefile in this project will lint or sometimes just format any shell,
Python, golang, Terraform, or Dockerfiles. The linters will only be run if
the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to
run

```
make -s
```

The -s is for 'silent'. Successful output looks like this

```
Running shellcheck
Running flake8
Running go fmt and go vet
Running terraform validate
Running hadolint on Dockerfiles
Checking for required files
Testing the validity of the header check
..
----------------------------------------------------------------------
Ran 2 tests in 0.026s

OK
Checking file headers
The following lines have trailing whitespace
```

The linters
are as follows:
* Shell - shellcheck. Can be found in homebrew
* Python - flake8. Can be installed with 'pip install flake8'
* Golang - gofmt. gofmt comes with the standard golang installation. golang
is a compiled language so there is no standard linter.
* Terraform - terraform has a built-in linter in the 'terraform validate'
command.
* Dockerfiles - hadolint. Can be found in homebrew
