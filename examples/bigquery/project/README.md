# Log Export: BigQuery destination at Project level

This example configures a project-level log sink that feeds a bigquery dataset destination

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bigquery\_options | (Optional) Options that affect sinks exporting data to BigQuery. use\_partitioned\_tables - (Required) Whether to use BigQuery's partition tables. | <pre>object({<br>    use_partitioned_tables = bool<br>  })</pre> | `null` | no |
| parent\_resource\_id | The ID of the project in which BigQuery dataset destination will be created. | `string` | n/a | yes |
| project\_id | The ID of the project in which the log export will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| destination\_map | Outputs from the destination module |
| log\_export\_map | Outputs from the log export module |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
