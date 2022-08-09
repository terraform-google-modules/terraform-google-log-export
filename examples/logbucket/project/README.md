# Log Export: Log Bucket destination at Project level

These examples configures a project-level log sink that feeds a logging log bucket destination with log bucket and log sink in the same project or in separated projects.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_resource\_project | The ID of the project in which the log export will be created. | `string` | n/a | yes |
| project\_destination\_logbkt\_id | The ID of the project in which log bucket destination will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| log\_bkt\_name\_same\_proj | The name for the log bucket for sink and logbucket in same project example. |
| log\_bkt\_same\_proj | The project where the log bucket is created for sink and logbucket in same project example. |
| log\_bucket\_name | The name for the log bucket. |
| log\_bucket\_project | The project where the log bucket is created. |
| log\_sink\_dest\_uri\_same\_proj | A fully qualified URI for the log sink for sink and logbucket in same project example. |
| log\_sink\_destination\_uri | A fully qualified URI for the log sink. |
| log\_sink\_id\_same\_proj | The project id where the log sink is created for sink and logbucket in same project example. |
| log\_sink\_project\_id | The project id where the log sink is created. |
| log\_sink\_resource\_name | The resource name of the log sink that was created. |
| log\_sink\_resource\_name\_same\_proj | The resource name of the log sink that was created in same project example. |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. |
| log\_sink\_writer\_identity\_same\_proj | The service account in same project example that logging uses to write log entries to the destination. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
