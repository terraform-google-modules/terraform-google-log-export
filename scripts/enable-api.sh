#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

API_URL=$1
PROJECT_NAME=$2

echo "API NAME: $API_URL"
api_enabled=$(gcloud services list --project=$PROJECT_NAME | grep $API_URL)

# Enable API if not already enabled
if [ -z "$api_enabled" ]
then
  echo "Enabling $API_URL ..."
  gcloud services enable $API_URL --project=$PROJECT_NAME
  echo "$API_URL enabled successfully."
else
  echo "$API_URL is already enabled."
fi
