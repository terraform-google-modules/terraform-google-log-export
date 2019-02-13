Logsink examples
================

Examples to create logsinks on Google Cloud Platform using the `logsink` module.

Variables
---------
The Terraform variables for all the examples are defined in the `terraform.tfvars.sample` in the [examples](./examples)
directory. This file is symlinked to every example directory. Replace all the variables by your own before running the examples.

Examples
--------
Examples are structured as follows:

* ***project-sink/*** creates 3 project-level sinks (Pub/Sub, Cloud Storage, BigQuery)

* ***folder-sink/*** creates 3 folder-level aggregated sinks (Pub/Sub, Cloud Storage, BigQuery)

* ***org-sink/*** creates 3 organization-level aggregated sinks (Pub/Sub, Cloud Storage, BigQuery)

* ***splunk-sink/*** creates 1 project-level sink to Pub/Sub in order to be ingested to Splunk

Each example can be run individually by going to each folder and running:

```
terraform init
terraform apply --var-file=terraform.tfvars.sample
```

Scripts
-------

Scripts have been written to automate running all the examples on an organization:

* `./apply_all.sh` will run all the examples (thus creating 1 folder, 1 project and 10 log sinks).

* `./destroy_all.sh` will destroy all the resources previously created.

* `./cleanup.sh` will clean up all the `terraform.tfstate*` files and the `.terraform` folders in each directory.
