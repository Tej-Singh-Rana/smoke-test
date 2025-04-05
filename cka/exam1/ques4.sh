#!/bin/bash

kubectl expose pod messaging --name=messaging-service --port=6379 --target-port=6379 --type=ClusterIP

sleep 2

kubectl get po,svc 
