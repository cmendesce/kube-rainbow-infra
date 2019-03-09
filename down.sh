#!/bin/bash
#rm -rf ./out

kubectl delete -f ./namespaces.yaml
kubectl delete -f ./metrics-server
kubectl delete -f ./prometheus
kubectl delete -f ./grafana
kubectl delete -f ./custom-metrics-api
kubectl delete -f ./znn
kubectl delete -f ./kubow/config
kubectl delete -f ./kubow/kubow-deployment.yaml

kubectl delete secret mysql-pass
kubectl delete -f ./znn

echo "Actual state of kubernetes components"
kubectl get all