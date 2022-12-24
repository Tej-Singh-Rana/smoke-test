#!/bin/bash


kubectl scale deploy nginx-deploy --replicas=3

kubectl get deploy nginx-deploy

sed -i 's/kube-contro1ler-manager/kube-controller-manager/g' /etc/kubernetes/manifests/kube-controller-manager.yaml

sleep 2

kubectl get deploy



