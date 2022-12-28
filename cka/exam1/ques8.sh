#!/bin/bash

kubectl run temp-bus --image=redis:alpine --namespace=finance --restart=Never


kubectl get po -n finance

