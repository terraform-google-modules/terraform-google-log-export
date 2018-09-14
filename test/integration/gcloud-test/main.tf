locals {
  credentials_file_path = "/Users/ocervello/rnm-shared-devops-fd8a7717d6e8.json"
}

provider "google" {
  credentials = "${file(local.credentials_file_path)}"
}

module "pubsub_sink" {
  source = "../../../"
  name   = "integration-project-sink-pubsub"
  project = "rnm-cloud-foundation-dev"
  pubsub = {
    name    = "integration-sink"
    project = "rnm-cloud-foundation-dev"
    create_subscriber = true
  }
}

module "storage_sink" {
  source = "../../../"
  name   = "integration-folder-sink-storage"
  folder = "1059264462455"
  storage = {
    name    = "rnm-integration-sink"
    project = "rnm-cloud-foundation-dev"
  }
}

module "bigquery_sink" {
  source = "../../../"
  name   = "integration-org-sink-bigquery"
  org_id = "430062980571"
  bigquery = {
    name     = "integration_sink"
    project  = "rnm-cloud-foundation-dev"
  }
}
