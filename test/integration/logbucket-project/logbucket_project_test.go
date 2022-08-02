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

const (
	defaultRetentionDays int64 = 30
)

func TestLogBucketProjectModule(t *testing.T) {

	bpt := tft.NewTFBlueprintTest(t,
		tft.WithTFDir("../../../examples/logbucket/project"),
	)
	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		for _, tc := range []struct {
			projId             string
			bktName            string
			sinkDest           string
			sinkProjId         string
			sinkName           string
			sinkWriterIdentity string
		}{
			{
				projId:             bpt.GetStringOutput("log_bucket_project"),
				bktName:            bpt.GetStringOutput("log_bucket_name"),
				sinkDest:           bpt.GetStringOutput("log_sink_destination_uri"),
				sinkProjId:         bpt.GetStringOutput("log_sink_project_id"),
				sinkName:           bpt.GetStringOutput("log_sink_resource_name"),
				sinkWriterIdentity: bpt.GetStringOutput("log_sink_writer_identity"),
			},
			{
				projId:             bpt.GetStringOutput("log_bkt_same_proj"),
				bktName:            bpt.GetStringOutput("log_bkt_name_same_proj"),
				sinkDest:           bpt.GetStringOutput("log_sink_dest_uri_same_proj"),
				sinkProjId:         bpt.GetStringOutput("log_sink_id_same_proj"),
				sinkName:           bpt.GetStringOutput("log_sink_resource_name_same_proj"),
				sinkWriterIdentity: "",
			},
		} {
			//************************
			// Assert bucket details *
			//************************
			bktFullName := fmt.Sprintf("projects/%s/locations/%s/buckets/%s", tc.projId, "global", tc.bktName)
			logBucketDetails := gcloud.Runf(t, fmt.Sprintf("logging buckets describe %s --location=%s --project=%s", tc.bktName, "global", tc.projId))

			// assert log bucket name, retention days & location
			assert.Equal(bktFullName, logBucketDetails.Get("name").String(), "log bucket name should match")
			assert.Equal(defaultRetentionDays, logBucketDetails.Get("retentionDays").Int(), "retention days should match")

			logSinkDetails := gcloud.Runf(t, fmt.Sprintf("logging sinks describe %s --project=%s", tc.sinkName, tc.sinkProjId))

			// assert log sink name, destination & filter
			assert.Equal(tc.sinkDest, logSinkDetails.Get("destination").String(), "log sink destination should match")
			assert.Equal("resource.type = gce_instance", logSinkDetails.Get("filter").String(), "log sink filter should match")
			assert.Equal(tc.sinkWriterIdentity, logSinkDetails.Get("writerIdentity").String(), "log sink writerIdentity should not be empty")
		}

		//*****************************
		// Assert SAs and Permissions *
		//*****************************
		bktDestProjId := bpt.GetStringOutput("log_bkt_same_proj")
		sinkWriterIdentity := bpt.GetStringOutput("log_sink_writer_identity")

		projPermissionsDetails := gcloud.Runf(t, fmt.Sprintf("projects get-iam-policy %s", bktDestProjId))
		listMembers := utils.GetResultStrSlice(projPermissionsDetails.Get("bindings.#(role==\"roles/logging.bucketWriter\").members").Array())

		// assert sink writer identity service account permission
		assert.Contains(listMembers, sinkWriterIdentity, "log sink writer identity permission should match")
		assert.Len(listMembers, 1, "only one writer identity should have logbucket write permission")
	})
	bpt.Test()
}
