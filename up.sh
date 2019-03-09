#!/bin/bash

if [ ! -d = "./out" ]; then
  make certs
fi;

kubectl apply -f ./namespaces.yaml
kubectl apply -f ./metrics-server
kubectl apply -f ./prometheus
kubectl apply -f ./grafana
kubectl apply -f ./custom-metrics-api
kubectl apply -f ./znn
#kubectl apply -f ./kubow/config
#kubectl apply -f ./kubow/kubow-deployment.yaml

kubectl get all --all-namespaces
