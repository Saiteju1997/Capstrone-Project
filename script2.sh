#!/bin/bash
cd /inet
kubectl delete -f Dev-deployment.yml
kubectl create -f Dev-namespace.yml
kubectl create -f Dev-deployment.yml
kubectl create -f Dev-service.yml
kubectl create -f Dev-resouceQuota.yml

