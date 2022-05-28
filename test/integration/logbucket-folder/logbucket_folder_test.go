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

package logbucket_folder

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestLogBucketFolderModule(t *testing.T) {

	const logApiFdqm = "logging.googleapis.com"
	const logBucketLocation = "global"

	insSimpleT := tft.NewTFBlueprintTest(t)
	insSimpleT.DefineVerify(func(assert *assert.Assertions) {
		insSimpleT.DefaultVerify(assert)

		projectId := insSimpleT.GetStringOutput("log_bucket_project")
		logBucketName := insSimpleT.GetStringOutput("log_bucket_name")
		logSinkFolderId := insSimpleT.GetStringOutput("log_sink_folder_id")
		logSinkDestination := insSimpleT.GetStringOutput("log_sink_destination_uri")

		logBucketDetails := gcloud.Runf(t, fmt.Sprintf("logging buckets describe %s --location=%s --project=%s", logBucketName, logBucketLocation, projectId))

		// assert log bucket name, retention days & location
		assert.Equal(logSinkDestination[len(logApiFdqm)+1:], logBucketDetails.Get("name").String(), "log bucket name should match")
		assert.Equal(int64(30), logBucketDetails.Get("retentionDays").Int(), "retention days should match")

		logSinkDetails := gcloud.Runf(t, fmt.Sprintf("logging sinks describe %s --folder=%s", logBucketName, logSinkFolderId))

		// assert log sink name, destination & filter
		assert.Equal(logSinkDestination, logSinkDetails.Get("destination").String(), "log sink destination should match")
		assert.Equal("resource.type = gce_instance", logSinkDetails.Get("filter").String(), "log sink filter should match")

	})
	insSimpleT.Test()
}
