#!/bin/bash


kubectl scale deploy nginx-deploy --replicas=3


sed -i 's/kube-contro1ler-manager/kube-controller-manager/g' /etc/kubernetes/manifests/kube-controller-manager.yaml


kubectl get deploy


