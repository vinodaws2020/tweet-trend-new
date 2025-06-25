#!/bin/sh
kubectl apply -f namespace.yml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

