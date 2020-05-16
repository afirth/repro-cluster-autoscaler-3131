#!/usr/bin/env bash
set -eux -o pipefail

export CLUSTER="broken-3131-115"
export VERSION="1.15.11-gke.11"
export PROJECT=$(gcloud config get-value project)

source test-env.sh

create_cluster
add_node_pool_as
./hammer.sh
