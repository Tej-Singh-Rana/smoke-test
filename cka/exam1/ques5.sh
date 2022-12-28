#!/bin/bash

kubectl expose pod messaging --port=6379 --name messaging-service

sleep 2

kubectl get po,svc 

