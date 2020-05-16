#!/usr/bin/env bash
set -eux -o pipefail

create_cluster() {
  gcloud container \
    --project $PROJECT clusters create $CLUSTER \
    --zone europe-west1-d \
    --cluster-version $VERSION \
    --preemptible \
    --num-nodes "1" \
    --enable-autoscaling --max-nodes=5 --min-nodes=1 \
    --default-max-pods-per-node "110" \
    --machine-type "n1-standard-4" \
    --disk-type "pd-ssd" \
    --disk-size "50" \
    --image-type "COS" \
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
}

add_node_pool_as() {
  gcloud container \
    --project $PROJECT node-pools create pool-2 --cluster $CLUSTER \
    --zone europe-west1-d \
    --preemptible \
    --num-nodes "1" \
    --enable-autoscaling --max-nodes=5 --min-nodes=1 \
    --machine-type "n1-highmem-8" \
    --disk-type "pd-ssd" \
    --disk-size "50" \
    --image-type "COS" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/ndev.clouddns.readwrite" \
    --enable-autoupgrade \
    --enable-autorepair \
    --shielded-secure-boot \
    --metadata disable-legacy-endpoints=true
}

add_node_pool_no_as() {
  gcloud container \
    --project $PROJECT node-pools create pool-2 --cluster $CLUSTER \
    --zone europe-west1-d \
    --preemptible \
    --num-nodes "1" \
    --machine-type "n1-highmem-8" \
    --disk-type "pd-ssd" \
    --disk-size "50" \
    --image-type "COS" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/ndev.clouddns.readwrite" \
    --enable-autoupgrade \
    --enable-autorepair \
    --shielded-secure-boot \
    --metadata disable-legacy-endpoints=true
}

enable_as() {
  gcloud container \
    --project $PROJECT node-pools update pool-2 --cluster $CLUSTER\
    --zone europe-west1-d \
    --enable-autoscaling --max-nodes=5 --min-nodes=1
}

disable_as() {
  gcloud container \
    --project $PROJECT node-pools update pool-2 --cluster $CLUSTER\
    --zone europe-west1-d \
    --no-enable-autoscaling
}
