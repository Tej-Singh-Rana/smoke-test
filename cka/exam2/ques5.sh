#!/bin/bash

kubectl create deployment nginx-deploy --image=nginx:1.16 --dry-run=client -o yaml > deploy.yaml


kubectl apply -f deploy.yaml --record


kubectl rollout history deployment nginx-deploy

kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record

kubectl rollout history deployment nginx-deploy


