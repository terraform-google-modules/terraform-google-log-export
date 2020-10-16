# Log Export: BigQuery destination at Folder level

This example configures a folder-level log sink that feeds a bigquery dataset destination

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_resource\_id | The ID of the project in which BigQuery dataset destination will be created. | `string` | n/a | yes |
| project\_id | The ID of the project in which the log export will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| destination\_map | Outputs from the destination module |
| log\_export\_map | Outputs from the log export module |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
