#!/bin/bash

if [ ! -d = "./monitoring/out" ]; then
  make certs
fi;

kubectl apply -f ./monitoring/namespaces.yaml
kubectl apply -f ./monitoring/metrics-server
kubectl apply -f ./monitoring/prometheus
kubectl apply -f ./monitoring/grafana
kubectl apply -f ./monitoring/custom-metrics-api

kubectl apply -f ./znn

kubectl get all
