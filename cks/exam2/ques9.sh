#!/bin/bash

echo "Image: nginx" 
trivy image --severity=CRITICAL nginx | grep -i total

echo "Image: nginx:1.19" 
trivy image --severity=CRITICAL nginx:1.19 | grep -i total

echo "Image: nginx:1.17" 
trivy image --severity=CRITICAL nginx:1.17 | grep -i total

echo "Image: nginx:1.20" 
trivy image --severity=CRITICAL nginx:1.20 | grep -i total

echo "Image: gcr.io/google-containers/nginx" 
trivy image --severity=CRITICAL gcr.io/google-containers/nginx | grep -i total

echo "Image: bitnami/jenkins:latest" 
trivy image --severity=CRITICAL bitnami/jenkins:latest | grep -i total

kubectl run secure-nginx-pod --image=gcr.io/google-containers/nginx -n seth

sleep 2
kubectl get po -n seth

sleep 2
kubectl get po -n seth

