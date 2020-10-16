# Splunk sink example

The solution helps you set up a log-streaming pipeline from Stackdriver Logging to Splunk.

The example is for a project-level sink, but it can be easily be adapted for aggregated log sinks.

## Instructions

1. Fill the required variables in the `terraform.tfvars.sample` file located in the `examples/` directory.

2. Verify the IAM roles for your Terraform service account:
    - `roles/logging.configWriter` on the project (to create the logsink)
    - `roles/iam.admin` on the project (to grant write permissions for logsink service account)
    - `roles/serviceusage.admin` on the destination project (to enable destination API)
    - `roles/pubsub.admin` on the destination project (to create a pub/sub topic)
    - `roles/serviceAccount.admin` on the destination project (to create a service account for the logsink subscriber)

2. Run the Terraform automation:
    ```
    terraform init
    terraform apply
    ```

    You should see similar outputs as the following:

    ![screen shot 2019-01-25 at 1 21 14 pm](https://user-images.githubusercontent.com/9629314/51767833-23459980-20a4-11e9-831c-01a2943ee745.png)

3. In the GCP console, under `IAM > Service Accounts`, find the Pub/Sub subscriber service account and create a set of JSON credentials:

    ![screen shot 2019-01-25 at 1 24 27 pm](https://user-images.githubusercontent.com/9629314/51767992-8fc09880-20a4-11e9-8e69-aa8b3f6e360d.png)

4. Go to your `Splunk` web console. On the left panel, click on the big `+` squared box:

    ![screen shot 2019-01-25 at 1 28 10 pm](https://user-images.githubusercontent.com/9629314/51768142-170e0c00-20a5-11e9-9190-eac68a057e86.png)

5. Search for the `Google Cloud Platform` add-on and install it.

    ![screen shot 2019-01-25 at 1 30 00 pm](https://user-images.githubusercontent.com/9629314/51768246-65bba600-20a5-11e9-829f-2feae4f295dd.png)

    *Note: you might need to restart your Splunk instance after the installation.*

5. Click on the add-on tile and navigate to the `Configuration` tab. Under the `Google Credentials` menu item, click on `Add Credential`.

    ![screen shot 2019-01-25 at 1 34 16 pm](https://user-images.githubusercontent.com/9629314/51768443-f72b1800-20a5-11e9-955c-4c3ae6952e7f.png)

6. Copy the content of the downloaded JSON file to the popup window:

    ![screen shot 2019-01-25 at 1 37 17 pm](https://user-images.githubusercontent.com/9629314/51768595-5c7f0900-20a6-11e9-9135-d28fa4fbff20.png)

7. Switch to the `Inputs` tab, and click on `Create New Input` and select `Cloud Pub/Sub`.

8. Fill the required values from the Terraform outputs, and click `Add`:

    ![screen shot 2019-01-25 at 1 39 16 pm](https://user-images.githubusercontent.com/9629314/51768687-a1a33b00-20a6-11e9-9871-b4b6c97f29bb.png)

    *Note: If you have lost the Terraform outputs, simply run `terraform output` in this directory to see them again.*

9. Switch to the `Search` tab. You should see that Splunk ingested some events:

    ![screen shot 2019-01-25 at 1 42 25 pm](https://user-images.githubusercontent.com/9629314/51768902-33ab4380-20a7-11e9-8f91-22d4eed777e7.png)

10. **Congratulations !** Your Stackdriver-to-Splunk logging pipeline is up and running !

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_resource\_id | The ID of the project in which pubsub topic destination will be created. | `string` | n/a | yes |
| project\_id | The ID of the project in which the log export will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| pubsub\_subscriber | Pub/Sub topic subscriber email |
| pubsub\_subscription\_name | Pub/Sub topic subscription name |
| pubsub\_topic\_name | Pub/Sub topic name |
| pubsub\_topic\_project | Pub/Sub topic project id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
