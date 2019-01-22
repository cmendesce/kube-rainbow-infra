#!/bin/bash
#rm -rf ./out

kubectl delete -f ./metrics-server
kubectl delete -f ./namespaces.yaml
kubectl delete -f ./prometheus
kubectl delete -f ./custom-metrics-api

kubectl delete secret mysql-pass
kubectl delete -f ./znn

echo "Actual state of kubernetes components"
kubectl get all