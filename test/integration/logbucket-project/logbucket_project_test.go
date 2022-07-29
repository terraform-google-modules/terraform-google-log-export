// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package logbucket_project

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

func TestLogBucketProjectModule(t *testing.T) {

	const logApiFdqm = "logging.googleapis.com"
	const RETENTION_DAYS = 20
	const SAMEPROJ_LOGSINK_WRITER_IDENTITY string = ""
	const ROLE_BUCKET_WRITER string = "roles/logging.bucketWriter"

	insSimpleT := tft.NewTFBlueprintTest(t,
		tft.WithTFDir("../../../examples/logbucket/project"),
	)
	insSimpleT.DefineVerify(func(assert *assert.Assertions) {
		insSimpleT.DefaultVerify(assert)

		//*******************************
		// Bucket on other project test *
		//*******************************
		projectId := insSimpleT.GetStringOutput("log_bucket_project")
		logBucketName := insSimpleT.GetStringOutput("log_bucket_name")
		logBucketDestinationProjId := insSimpleT.GetStringOutput("log_bucket_project_same_project_example")
		logSinkProjectId := insSimpleT.GetStringOutput("log_sink_project_id")
		logSinkDestination := insSimpleT.GetStringOutput("log_sink_destination_uri")
		logSinkName := insSimpleT.GetStringOutput("log_sink_resource_name")
		logSinkWriterIdentity := insSimpleT.GetStringOutput("log_sink_writer_identity")

		logBucketDetails := gcloud.Runf(t, fmt.Sprintf("logging buckets describe %s --location=%s --project=%s", logBucketName, "global", projectId))

		// assert log bucket name, retention days & location
		assert.Equal(logSinkDestination[len(logApiFdqm)+1:], logBucketDetails.Get("name").String(), "log bucket name should match")
		assert.Equal(int64(30), logBucketDetails.Get("retentionDays").Int(), "retention days should match")

		logSinkDetails := gcloud.Runf(t, fmt.Sprintf("logging sinks describe %s --project=%s", logSinkName, logSinkProjectId))

		// assert log sink name, destination & filter
		assert.Equal(logSinkDestination, logSinkDetails.Get("destination").String(), "log sink destination should match")
		assert.Equal("resource.type = gce_instance", logSinkDetails.Get("filter").String(), "log sink filter should match")
		assert.Equal(logSinkWriterIdentity, logSinkDetails.Get("writerIdentity").String(), "log sink writerIdentity should not be empty")


		//**********************************
		// Bucket on the same project test *
		//**********************************
		sameProjId := insSimpleT.GetStringOutput("log_bucket_project_same_project_example")
		sameProjLogBucketName := insSimpleT.GetStringOutput("log_bucket_name_same_project_example")
		sameProjLogSinkProjectId := insSimpleT.GetStringOutput("log_sink_project_id_same_project_example")
		sameProjLogSinkDestination := insSimpleT.GetStringOutput("log_sink_destination_uri_same_project_example")
		sameProjLogSinkName := insSimpleT.GetStringOutput("log_sink_resource_name_same_project_example")

		assert.NotEqual(sameProjId, "a", "log sink destination should match")
		assert.NotEqual(sameProjLogBucketName, "", "log sink destination should match")
		assert.NotEqual(sameProjLogSinkProjectId, "", "log sink destination should match")
		assert.NotEqual(sameProjLogSinkDestination, "", "log sink destination should match")

		sameProjLogBucketDetails := gcloud.Runf(t, fmt.Sprintf("logging buckets describe %s --location=%s --project=%s", sameProjLogBucketName, "global", sameProjId))

		// assert log bucket name, retention days & location
		assert.Equal(sameProjLogSinkDestination[len(logApiFdqm)+1:], sameProjLogBucketDetails.Get("name").String(), "log bucket name should match")
		assert.Equal(int64(RETENTION_DAYS), sameProjLogBucketDetails.Get("retentionDays").Int(), "retention days should match")

		sameProjLogSinkDetails := gcloud.Runf(t, fmt.Sprintf("logging sinks describe %s --project=%s", sameProjLogSinkName, sameProjLogSinkProjectId))

		// assert log sink name, destination & filter
		assert.Equal(sameProjLogSinkDestination, sameProjLogSinkDetails.Get("destination").String(), "log sink destination should match")
		assert.Equal("resource.type = gce_instance", sameProjLogSinkDetails.Get("filter").String(), "log sink filter should match")
		assert.Equal(SAMEPROJ_LOGSINK_WRITER_IDENTITY, sameProjLogSinkDetails.Get("writerIdentity").String(), "log sink writerIdentity should not be empty")


		//***************************
		// Test SAs and Permissions *
		//***************************
		projPermissionsDetails := gcloud.Runf(t, fmt.Sprintf("projects get-iam-policy %s", logBucketDestinationProjId))
		listMembers := utils.GetResultStrSlice(projPermissionsDetails.Get("bindings.#(role==\""+ ROLE_BUCKET_WRITER +"\").members").Array())

		// assert sink writer identity service account permission
		assert.Contains(listMembers, logSinkWriterIdentity, "log sink writer identity permission should match")
		assert.Equal(int(1), len(listMembers), "only one writer identity should have logbucket write permission")
	})
	insSimpleT.Test()
}
