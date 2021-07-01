# Log Export: Storage destination at Organization level

This example configures a organization-level log sink that feeds a storage bucket destination. Storage bucket versioning is turned on to mitigate possible modify or delete log events.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_resource\_id | The ID of the project in which storage bucket destination will be created. | `string` | n/a | yes |
| project\_id | The ID of the project in which the log export will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| destination\_map | Outputs from the destination module |
| log\_export\_map | Outputs from the log export module |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
