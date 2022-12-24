#!/bin/bash

kubectl run nginx-critical --image=nginx --dry-run=client -o yaml > static.yaml


scp static.yaml node01:/etc/kubernetes/manifests/

ssh node01 'cat /var/lib/kubelet/config.yaml | grep staticPodPath'

ssh node 'ls -l /etc/kubernetes/manifests/'

echo "Check the status of the static pod" 

kubectl get po -o wide 

