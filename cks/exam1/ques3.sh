#!/bin/bash

echo "Image name" 
kubectl -n delta get pods -o json | jq -r '.items[].spec.containers[].image'

echo "Pod name"
kubectl -n delta get pods -o json | jq -r '.items[].metadata.name'


trivy image --severity CRITICAL kodekloud/webapp-delayed-start | grep Total
echo " "

trivy image --severity CRITICAL httpd:2-alpine | grep Total
echo " "

trivy image --severity CRITICAL nginx:1.16 | grep Total
echo " "

trivy image --severity CRITICAL httpd:2.4.33 | grep Total
echo " "

echo "Deleting critical pods" 

kubectl delete po -n delta simple-webapp-1 --force

kubectl delete po -n delta simple-webapp-3 --force

kubectl delete po -n delta simple-webapp-4 --force

