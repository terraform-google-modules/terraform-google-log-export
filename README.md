# Terraform Log Export Module
This module allows you to create log exports at the project, folder, or organization level.

The resources/services/activations/deletions that this module will create/trigger are:
- An **Aggregated log export** on the project-level, folder-level, or organization-level
- A **Service account** (logsink writer)
- A **Destination** (Cloud Storage bucket, Cloud Pub/Sub topic, BigQuery dataset)

## Usage
You can go to the [examples](./examples) folder to see all the use cases, however the usage of the module could be like this in your own `main.tf` file:

```
module "logsink" {
  source           = "github.com/terraform-google-modules/terraform-google-log-export"
  name             = "my-logsink"
  folder           = "2165468435"
  filter           = "severity >= ERROR"
  include_children = true
  pubsub = {
    name    = "my-logsink-pubsub"
    project = "my-pubsub-project"
  }
}
```

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0

### Configure a Service Account
In order to execute this module you must have a Service Account with the following:

#### Roles
The service account should have the following roles:
- `roles/logging.configWriter` on the logsink's project, folder, or organization (to create the logsink)
- `roles/iam.admin` on the destination project (to grant write permissions for logsink service account)
- `roles/serviceusage.admin` on the destination project (to enable destination API)

#### Pub/Sub roles
To use a Google Cloud Pub/Sub topic as the destination:
- `roles/pubsub.admin` on the destination project (to create a pub/sub topic)

To integrate the logsink with Splunk, you'll need a topic subscriber (service account):
- `roles/serviceAccount.admin` on the destination project (to create a service account for the logsink subscriber)

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

## Install

### Terraform
Be sure you have the correct Terraform version (0.10.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

Then perform the following commands:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

#### Variables
Please refer the `variables.tf` file for the required and optional variables.

#### Outputs
Please refer the `outputs.tf` file for the outputs that you can get with the `terraform output` command

## File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /scripts: Shell scripts for specific tasks on module
- /test: Folders with files for testing the module (see Testing section on this file)
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module
- /readme.MD: this file

## Testing

### Requirements
- [bats](https://github.com/sstephenson/bats) 0.4.0

### Integration test
##### Terraform integration tests
The integration tests for this module are built with bats, basically the test checks the following:
- Perform `terraform init` command
- Perform `terraform get` command
- Perform `terraform plan` command and check that it'll create *n* resources, modify 0 resources and delete 0 resources
- Perform `terraform apply -auto-approve` command and check that it has created the *n* resources, modified 0 resources and deleted 0 resources
- Perform several `gcloud` commands and check the infrastructure is in the desired state
- Perform `terraform destroy -force` command and check that it has destroyed the *n* resources

You can use the following command to run the integration test in the folder */test/integration/gcloud-test*

  `. launch.sh`
