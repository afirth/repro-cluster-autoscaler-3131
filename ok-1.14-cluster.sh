#!/usr/bin/env bash
set -eux -o pipefail

#doesn't break on 1.14

export CLUSTER="ok-3131-114"
export VERSION="1.14.10-gke.27"
export PROJECT=$(gcloud config get-value project)

source test-env.sh

create_cluster
add_node_pool_as
./hammer.sh
