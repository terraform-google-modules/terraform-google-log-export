# Log Export: Log Bucket destination at Folder level

These examples configures a project-level log sink that feeds a logging log bucket destination with log bucket and log sink in the same project and in separated projects.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_resource\_project | The ID of the project in which the log export will be created. | `string` | n/a | yes |
| project\_id | The ID of the project in which log bucket destination will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| log\_bucket\_name | The name for the log bucket. |
| log\_bucket\_name\_same\_project\_example | The name for the log bucket for sink and logbucket in same project example. |
| log\_bucket\_project | The project where the log bucket is created. |
| log\_bucket\_project\_same\_project\_example | The project where the log bucket is created for sink and logbucket in same project example. |
| log\_sink\_destination\_uri | A fully qualified URI for the log sink. |
| log\_sink\_destination\_uri\_same\_project\_example | A fully qualified URI for the log sink for sink and logbucket in same project example. |
| log\_sink\_folder\_id\_same\_project\_example | The folder id where the log sink is created for sink and logbucket in same project example. |
| log\_sink\_project\_id | The project id where the log sink is created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
