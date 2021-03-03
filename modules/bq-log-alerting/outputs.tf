/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "cloud_scheduler_job_name" {
  value       = module.bq-log-alerting.name
  description = "The name of the Cloud Scheduler job created"
}

output "pubsub_topic_name" {
  value       = module.bq-log-alerting.pubsub_topic_name
  description = "Pub/Sub topic name"
}

output "cloud_scheduler_job" {
  value       = module.bq-log-alerting.scheduler_job
  description = "The Cloud Scheduler job instance"
}

output "source_name" {
  value       = local.actual_source_name
  description = "The Security Command Center Source name for the \"BQ Log Alerts\" Source"
}

output "cloud_function_service_account_email" {
  value       = google_service_account.gcf_service_account.email
  description = "The email of the service account created to be used by the Cloud Function"
}

output "bq_views_dataset_id" {
  value       = google_bigquery_dataset.views_dataset.id
  description = "The ID of the BigQuery Views dataset"
}
