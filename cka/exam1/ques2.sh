#!/bin/bash

kubectl run messaging --image=redis:alpine -l tier=msg

sleep 2

kubectl get po -l tier=msg


