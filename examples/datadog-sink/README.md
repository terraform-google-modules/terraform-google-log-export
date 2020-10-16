# Datadog sink example

The solution helps you set up a log-streaming pipeline from Stackdriver Logging to Datadog.

## Instructions

1. Fill the required variables in the `terraform.tfvars.sample` file located in this directory.

2. Verify the IAM roles for your Terraform service account:
    - `roles/logging.configWriter` on the project (to create the logsink)
    - `roles/iam.admin` on the project (to grant write permissions for logsink service account)
    - `roles/serviceusage.admin` on the destination project (to enable destination API)
    - `roles/pubsub.admin` on the destination project (to create a pub/sub topic)
    - `roles/serviceAccount.admin` on the destination project (to create a service account for the logsink subscriber)

2. Run the Terraform automation:
    ```
    terraform init
    terraform apply
    ```

    You should see similar outputs as the following:

    ![output screenshot](https://github.com/smbreslow/terraform-google-log-export/raw/master/examples/datadog-sink/screenshots/Screen%20Shot%202019-12-09%20at%204.44.11%20PM.png)

3. Navigate to the [Datadog Google Cloud Integration Tile](http://app.datadoghq.com/account/settings#integrations/google_cloud_platform).

4. On the **Configuration** tab, select *Upload Key File* and upload the JSON file located at the specified `output_key_path`.
    ![datadog screenshot](https://docs.datadoghq.com/images/integrations/google_cloud_platform/ServiceAccountAdded.png?fit=max&auto=format)

5. Press *Install/Update*.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| key\_output\_path | The path to a directory where the JSON private key of the new Datadog service account will be created. | `string` | `"../datadog-sink/datadog-sa-key.json"` | no |
| parent\_resource\_id | The ID of the project in which pubsub topic destination will be created. | `string` | n/a | yes |
| project\_id | The ID of the project in which the log export will be created. | `string` | n/a | yes |
| push\_endpoint | The URL locating the endpoint to which messages should be pushed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| datadog\_service\_account | Datadog service account email |
| log\_writer | n/a |
| pubsub\_subscription\_name | Pub/Sub topic subscription name |
| pubsub\_topic\_name | Pub/Sub topic name |
| pubsub\_topic\_project | Pub/Sub topic project id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
