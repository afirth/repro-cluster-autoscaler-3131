#!/usr/bin/env bash
set -eux -o pipefail

PROJECT=$(gcloud config get-value project)
CLUSTER="repro-3131-114"
VERSION="1.14.10-gke.27"

gcloud container \
  --project $PROJECT clusters create $CLUSTER\
  --zone europe-west1-d \
  --cluster-version $VERSION \
  --preemptible \
  --num-nodes "2" \
  --enable-autoscaling --max-nodes=11 --min-nodes=1 \
  --default-max-pods-per-node "110" \
  --machine-type "n1-standard-4" \
  --disk-type "pd-ssd" \
  --disk-size "50" \
  --image-type "COS" \
  --addons HorizontalPodAutoscaling${_EXTRA_ADDONS} \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/ndev.clouddns.readwrite" \
  --enable-autoupgrade \
  --enable-autorepair \
  --enable-ip-alias \
  --enable-stackdriver-kubernetes \
  --enable-shielded-nodes \
  --shielded-secure-boot \
  --metadata disable-legacy-endpoints=true \
  --no-enable-basic-auth \
  --no-issue-client-certificate

poll() {
  gcloud container clusters describe $CLUSTER --format=json | jq -r '.status' | grep -q 'RUNNING'
}

while ! poll ; do
  echo $CLUSTER not ready
  echo sleep 20
done

gcloud container \
  --project $PROJECT node-pools create pool-2 --cluster $CLUSTER\
  --zone europe-west1-d \
  --preemptible \
  --num-nodes "2" \
  --enable-autoscaling --max-nodes=11 --min-nodes=1 \
  --machine-type "n1-highmem-8" \
  --disk-type "pd-ssd" \
  --disk-size "50" \
  --image-type "COS" \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/ndev.clouddns.readwrite" \
  --enable-autoupgrade \
  --enable-autorepair \
  --enable-shielded-nodes \
  --shielded-secure-boot \
  --metadata disable-legacy-endpoints=true
