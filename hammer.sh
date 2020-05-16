#!/usr/bin/env bash
set -eux -o pipefail

main() {
gcloud container clusters get-credentials $CLUSTER
CTX=$(kubectl config current-context)

for i in {0..10}; do

  # create and wait
  # mutating the name is required to reproduce
  SS_NAME=elasticsearch-$i
  create_ss
  sleep 30

  #delete
  delete_ss
  k describe cm -n kube-system cluster-autoscaler-status | grep ScaleUp | grep -v NoActivity || true
done

k get nodes
k get pods
}

create_ss(){
  sed "s/name: elasticsearch/name: $SS_NAME/" statefulset.yaml \
    | k apply -f -
}

delete_ss(){
  sed "s/name: elasticsearch/name: $SS_NAME/" statefulset.yaml \
  | k delete -f -
}

k() {
  kubectl --context=$CTX $@
}

main
