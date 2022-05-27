# Log Export: Storage destination at Organization level

This example configures a organization-level log sink that feeds a storage bucket destination. Storage bucket versioning is turned on to mitigate possible modify or delete log events.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_resource\_id | The ID of the organization in which the log export will be created. | `string` | n/a | yes |
| project\_id | The ID of the project in which storage bucket destination will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| log\_bucket\_name | The name for the log bucket. |
| log\_bucket\_project | The project where the log bucket is created. |
| log\_sink\_destination\_uri | A fully qualified URI for the log sink. |
| log\_sink\_organization\_id | The organization id where the log sink is created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
