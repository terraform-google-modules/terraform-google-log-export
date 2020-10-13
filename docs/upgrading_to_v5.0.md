# Upgrading to Log Export v5.0

The v5.0 release of Log Export is a backwards incompatible release and features many quality of life improvements.
Breaking changes have only been made to the storage and bigquery submodules.
Other modules can safely update the version without needing any changes.

## Migration Instructions

NOTE: Users should prefer to let Terraform update their resources to the newer defaults.
To preserve the existing defaults, see below:

```diff
module "gcs" {
  source            = "terraform-google-modules/log-export/google//modules/bigquery"
- version           = "v4.0"
+ version           = "v5.0"

+ delete_contents_on_destroy    = true

- default_table_expiration_ms = 3600000 # 1 hour
+ expiration_days             = 1 # 1 day
}
```

```diff
module "gcs" {
  source            = "terraform-google-modules/log-export/google//modules/storage"
- version           = "v4.0"
+ version           = "v5.0"

+  force_destroy = true
+  storage_class = "MULTI_REGIONAL"

- bucket_policy_only          = false
+ uniform_bucket_access_level = false
}
```
