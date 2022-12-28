#!/bin/bash

kubectl run nginx-pod --image=nginx:alpine

sleep 2

kubectl get po 

