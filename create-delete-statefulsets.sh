#!/usr/bin/env bash
set -eux -o pipefail

REPEATS=${1:-10}
DELAY=${2:-30}
YAML=${3:-statefulset.yaml}

main() {
gcloud container clusters get-credentials $CLUSTER
CTX=$(kubectl config current-context)

for ((i=0;i<=REPEATS;i++)); do

  # create and wait
  # mutating the name is required to reproduce
  SS_NAME=elasticsearch-$i
  create_ss
  sleep $DELAY

  #delete
  delete_ss
  k describe cm -n kube-system cluster-autoscaler-status | grep ScaleUp | grep -v NoActivity || true
done

k get nodes
k get pods
}

create_ss(){
  sed "s/name: elasticsearch/name: $SS_NAME/" $YAML \
    | k apply -f -
}

delete_ss(){
  sed "s/name: elasticsearch/name: $SS_NAME/" $YAML \
  | k delete -f -
}

k() {
  kubectl --context=$CTX $@
}

main
