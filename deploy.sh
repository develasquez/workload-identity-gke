#!/bin/bash
export PROJECT_ID=$1;
export TEMPLATE_VERSION=$2;
export REPLICAS=1
export SA_NAME=$3:

echo $PROJECT_ID;

gcloud builds submit --project=$PROJECT_ID --tag gcr.io/$PROJECT_ID/servicio:$TEMPLATE_VERSION
cat deployment.yaml | sed -e "s/{PROJECT_ID}/${PROJECT_ID}/g;" | sed -e "s/{TEMPLATE_VERSION}/${TEMPLATE_VERSION}/g;" | sed -e "s/{REPLICAS}/${REPLICAS}/g;" | sed -e "s/{SA_NAME}/${SA_NAME}/g;"   > deployment_version.yaml;
cat deployment_version.yaml;

gcloud container clusters get-credentials k8s --zone us-central1-a --project $PROJECT_ID
kubectl apply -f deployment_version.yaml;
kubectl apply -f service.yaml;