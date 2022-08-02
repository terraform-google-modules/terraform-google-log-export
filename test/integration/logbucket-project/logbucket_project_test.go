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

	const logApiFdqm, roleBucketWriter string = "logging.googleapis.com", "roles/logging.bucketWriter"
	const retentionDays int64 = 20

	bpt := tft.NewTFBlueprintTest(t,
		tft.WithTFDir("../../../examples/logbucket/project"),
	)
	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		//*******************************
		// Bucket on other project test *
		//*******************************
		projId := bpt.GetStringOutput("log_bucket_project")
		bktName := bpt.GetStringOutput("log_bucket_name")
		bktDestProjId := bpt.GetStringOutput("log_bkt_same_proj")
		sinkProjId := bpt.GetStringOutput("log_sink_project_id")
		sinkDest := bpt.GetStringOutput("log_sink_destination_uri")
		sinkName := bpt.GetStringOutput("log_sink_resource_name")
		sinkWriterIdentity := bpt.GetStringOutput("log_sink_writer_identity")

		logBucketDetails := gcloud.Runf(t, fmt.Sprintf("logging buckets describe %s --location=%s --project=%s", bktName, "global", projId))

		// assert log bucket name, retention days & location
		assert.Equal(sinkDest[len(logApiFdqm)+1:], logBucketDetails.Get("name").String(), "log bucket name should match")
		assert.Equal(int64(30), logBucketDetails.Get("retentionDays").Int(), "retention days should match")

		logSinkDetails := gcloud.Runf(t, fmt.Sprintf("logging sinks describe %s --project=%s", sinkName, sinkProjId))

		// assert log sink name, destination & filter
		assert.Equal(sinkDest, logSinkDetails.Get("destination").String(), "log sink destination should match")
		assert.Equal("resource.type = gce_instance", logSinkDetails.Get("filter").String(), "log sink filter should match")
		assert.Equal(sinkWriterIdentity, logSinkDetails.Get("writerIdentity").String(), "log sink writerIdentity should not be empty")

		//**********************************
		// Bucket on the same project test *
		//**********************************
		sameProjId := bpt.GetStringOutput("log_bkt_same_proj")
		sameProjBktName := bpt.GetStringOutput("log_bkt_name_same_proj")
		sameProjSinkProjId := bpt.GetStringOutput("log_sink_id_same_proj")
		sameProjSinkDest := bpt.GetStringOutput("log_sink_dest_uri_same_proj")
		sameProjSinkName := bpt.GetStringOutput("log_sink_resource_name_same_proj")

		sameProjBktDetails := gcloud.Runf(t, fmt.Sprintf("logging buckets describe %s --location=%s --project=%s", sameProjBktName, "global", sameProjId))

		// assert log bucket name, retention days & location
		assert.Equal(sameProjSinkDest[len(logApiFdqm)+1:], sameProjBktDetails.Get("name").String(), "log bucket name should match")
		assert.Equal(int64(retentionDays), sameProjBktDetails.Get("retentionDays").Int(), "retention days should match")

		sameProjSinkDetails := gcloud.Runf(t, fmt.Sprintf("logging sinks describe %s --project=%s", sameProjSinkName, sameProjSinkProjId))

		// assert log sink name, destination & filter
		assert.Equal(sameProjSinkDest, sameProjSinkDetails.Get("destination").String(), "log sink destination should match")
		assert.Equal("resource.type = gce_instance", sameProjSinkDetails.Get("filter").String(), "log sink filter should match")
		assert.Empty(sameProjSinkDetails.Get("writerIdentity").String(), "log sink writerIdentity same project should be empty")

		//***************************
		// Test SAs and Permissions *
		//***************************
		projPermissionsDetails := gcloud.Runf(t, fmt.Sprintf("projects get-iam-policy %s", bktDestProjId))
		listMembers := utils.GetResultStrSlice(projPermissionsDetails.Get("bindings.#(role==\"" + roleBucketWriter + "\").members").Array())

		// assert sink writer identity service account permission
		assert.Contains(listMembers, sinkWriterIdentity, "log sink writer identity permission should match")
		assert.Len(listMembers, 1, "only one writer identity should have logbucket write permission")
	})
	bpt.Test()
}
