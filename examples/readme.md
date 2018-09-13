Logsink examples
================

Examples to create logsinks on Google Cloud Platform using the `logsink` module.

Variables
---------
The Terraform variables for all the examples are defined in the `variables.tfvars` in the `examples/`
directory. Replace the variables by your own before running the examples.

Examples
--------
Examples are structured as follows:

* ***pubsub/*** creates 3 sinks (org-level, folder-level and project-level) with a Cloud Pub/Sub topic as the destination.

* ***gcs/*** creates 3 sinks (org-level, folder-level and project-level) with a Cloud Storage bucket as the destination. For testing purposes, the `gcs_bucket_prefix` and `gcs_bucket_suffix` are configurable.

* ***bigquery/*** creates 3 sinks (org-level, folder-level and project-level) with a BigQuery dataset as the destination.

* ***setup/*** creates a test folder identified by the variable `folder_name` and a test project identified by the variable `project_id`. This example **only** creates the structure required to run the other examples.
Skip running this if you already have a test folder and a test project created.

Each example can be run individually by going to each folder and running:

```
terraform init
terraform apply --var-file=../example.tfvars
```

Scripts
-------

Scripts have been written to automate running all the examples on an organization:

* `./apply_all.sh` will run all the examples (thus creating 1 folder, 1 project and 9 logsinks).

* `./destroy_all.sh` will destroy all the resources previously created.

* `./cleanup.sh` will clean up all the `terraform.tfstate*` files and the `.terraform` folders in each directory.
