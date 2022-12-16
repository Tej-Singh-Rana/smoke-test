#!/bin/bash

kubectl run nginx-critical --image=nginx --dry-run=client -o yaml > static.yaml


scp static.yaml node01:/etc/kubernetes/manifests/

ssh node01

cat /var/lib/kubelet/config.yaml | grep staticPodPath

ls -l /etc/kubernetes/manifests/

exit

kubectl get po -owide

