#!/bin/bash

# Copyright 2021 Google LLC
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

export PROJECT_ID=$1;
export TEMPLATE_VERSION=$2;
export REPLICAS=1
export SA_NAME=$3;

echo $PROJECT_ID;

gcloud builds submit --project=$PROJECT_ID --tag gcr.io/$PROJECT_ID/servicio:$TEMPLATE_VERSION
cat deployment.yaml | sed -e "s/{PROJECT_ID}/${PROJECT_ID}/g;" | sed -e "s/{TEMPLATE_VERSION}/${TEMPLATE_VERSION}/g;" | sed -e "s/{REPLICAS}/${REPLICAS}/g;" | sed -e "s/{SA_NAME}/${SA_NAME}/g;"   > deployment_version.yaml;
cat deployment_version.yaml;

gcloud container clusters get-credentials k8s --region us-central1 --project $PROJECT_ID
kubectl apply -f deployment_version.yaml;
kubectl apply -f service.yaml;