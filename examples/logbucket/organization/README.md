# Log Export: Log Bucket destination at Organization level

This example configures a organization-level log sink that feeds a Cloud Log Bucket destination.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_resource\_organization | The ID of the organization in which the log export will be created. | `string` | n/a | yes |
| project\_id | The ID of the project in which storage bucket destination will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| log\_bucket\_name | The name for the log bucket. |
| log\_bucket\_project | The project where the log bucket is created. |
| log\_sink\_destination\_uri | A fully qualified URI for the log sink. |
| log\_sink\_organization\_id | The organization id where the log sink is created. |
| log\_sink\_writer\_identity | Writer identity for the log sink that writes to the log bucket. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
