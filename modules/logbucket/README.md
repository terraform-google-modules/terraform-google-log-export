# Log Export: Storage destination submodule

This submodule allows you to configure a Google Cloud Storage bucket destination that
can be used by the log export created in the root module.

## Usage

The [examples](../../examples) directory contains directories for each destination, and within each destination directory are directories for each parent resource level. Consider the following
example that will configure a storage bucket destination and a log export at the project level:

```hcl
module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "storage_example_logsink"
  parent_resource_id     = "sample-project"
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = "sample-project"
  storage_bucket_name      = "sample_storage_bucket"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age        = 365
        with_state = "ANY"
      }
    },
    {
      action = {
        type = "SetStorageClass"
        storage_class = "COLDLINE"
      }
      condition = {
        age        = 180
        with_state = "ANY"
      }
    }
  ]
}
```

At first glance that example seems like a circular dependency as each module declaration is
using an output from the other, however Terraform is able to collect and order all the resources
so that all dependencies are met.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The location of the log bucket. | `string` | `"global"` | no |
| log\_bucket\_name | The name of the log bucket to be created and used for log entries matching the filter. | `string` | n/a | yes |
| project\_id | The ID of the project in which the log bucket will be created. | `string` | n/a | yes |
| retention\_days | The number of days data should be retained for the log bucket. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| console\_link | The console link to the destination log buckets |
| destination\_uri | The destination URI for the log bucket. |
| project | The project in which the log bucket was created. |
| resource\_name | The resource name for the destination log bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Customer Managed Encryption Key permission
IAM policy for the specified key must permit the automatic Google Cloud Storage service account for the bucket's project to use the specified key for encryption and decryption operations. Sample code for granting permission:

```hcl

data "google_storage_project_service_account" "gcs_account" {
  project = "gcp_bucket_project_id"
}

resource "google_kms_crypto_key_iam_member" "gcs_key_iam" {
  crypto_key_id = "kms_key_id"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

```
