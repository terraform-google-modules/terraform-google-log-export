# TODO: Add this in
# resource "google_project_iam_custom_role" "log-consumer-role" {
#   count       = "${var.enable_splunk}"
#   role_id     = "LogConsumerRole"
#   title       = "Log Consumer Role"
#   description = "A custom role to be used with the Splunk add-on for GCP"
#   stage       = "ALPHA"
#
#   permissions = [
#     "pubsub.subscriptions.list",
#     "resourcemanager.projects.get",
#   ]
# }
#
# resource "google_project_iam_binding" "log-consumer-role-binding" {
#   role = "${google_project_iam_custom_role.log-consumer-role.id}"
#
#   members = [
#     "serviceAccount:${google_service_account.log-consumer.email}",
#   ]
# }

