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

package logbucket_org

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestLogBucketOrgModule(t *testing.T) {

	const logApiFdqm = "logging.googleapis.com"

	insSimpleT := tft.NewTFBlueprintTest(t,
		tft.WithTFDir("../../../examples/logbucket/organization"),
	)

	insSimpleT.DefineVerify(func(assert *assert.Assertions) {
		insSimpleT.DefaultVerify(assert)

		projectId := insSimpleT.GetStringOutput("log_bucket_project")
		logBucketName := insSimpleT.GetStringOutput("log_bucket_name")
		logSinkOrgId := insSimpleT.GetStringOutput("log_sink_organization_id")
		logSinkDestination := insSimpleT.GetStringOutput("log_sink_destination_uri")
		logSinkWriterId := insSimpleT.GetStringOutput("log_sink_writer_identity")

		logBucketDetails := gcloud.Runf(t, fmt.Sprintf("logging buckets describe %s --location=%s --project=%s", logBucketName, "global", projectId))

		// assert log bucket name, retention days & location
		assert.Equal(logSinkDestination[len(logApiFdqm)+1:], logBucketDetails.Get("name").String(), "log bucket name should match")
		assert.Equal(int64(30), logBucketDetails.Get("retentionDays").Int(), "retention days should match")

		logSinkDetails := gcloud.Runf(t, fmt.Sprintf("logging sinks describe %s --organization=%s", logBucketName, logSinkOrgId))

		// assert log sink name, destination & filter
		assert.Equal(logSinkDestination, logSinkDetails.Get("destination").String(), "log sink destination should match")
		assert.Equal("resource.type = gce_instance", logSinkDetails.Get("filter").String(), "log sink filter should match")

		//assert writer id has the bucketWriter role
		logSinkServiceAccount := gcloud.Runf(t, "projects get-iam-policy %s --flatten bindings --filter bindings.role:roles/logging.bucketWriter", projectId)
		assert.Contains(logSinkServiceAccount.Array()[0].Get("bindings.members").String(), logSinkWriterId, "log sink SA has expected role")
	})
	insSimpleT.Test()
}
