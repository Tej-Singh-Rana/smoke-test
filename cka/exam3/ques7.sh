#!/bin/bash

kubectl create namespace hr


kubectl run hr-pod --image=redis:alpine --namespace=hr --labels=environment=production,tier=frontend

