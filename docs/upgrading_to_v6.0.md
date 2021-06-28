# Upgrading to Log Export v6.0

The v6.0 release of Log Export is a backwards incompatible release and features few additional features for log retenions and bucket policy lifecycles.

Breaking changes have only been made to the storage module.
Other modules can safely update the version without needing any changes.

## Migration Instructions

NOTE: Users should prefer to let Terraform update their resources to the newer defaults.
To preserve the existing defaults, see below:

```diff
module "gcs" {
  source            = "terraform-google-modules/log-export/google//modules/storage"
- version           = "v5.0"
+ version           = "v6.0"

- expiration_days          = 365
+  lifecycle_rules = [{
+    action = {
+      type = "Delete"
+    }
+    condition = {
+      age        = 365
+      with_state = "ANY"
+    }
+  }]
}
```
