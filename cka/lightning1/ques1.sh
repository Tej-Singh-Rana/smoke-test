#!/bin/bash

# Unholding 
apt-mark unhold kubelet kubeadm kubectl

kubectl drain controlplane --ignore-daemonsets
apt update
apt-get install kubeadm=1.25.0-00 -y 
kubeadm upgrade plan v1.25.0
kubeadm upgrade apply v1.25.0
apt-get install kubelet=1.25.0-00 -y
systemctl daemon-reload
systemctl restart kubelet
kubectl uncordon controlplane

echo "#######################################################"

# Identify the taint first. 
kubectl describe node controlplane | grep -i taint

# Remove the taint with help of "kubectl taint" command.
kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-

# Verify it, the taint has been removed successfully.  
kubectl describe node controlplane | grep -i taint


kubectl drain node01 --ignore-daemonsets

echo "#######################################################"
ssh node01

# Unholding 
apt-mark unhold kubelet kubeadm kubectl


apt update
apt-get install kubeadm=1.25.0-00 -y
kubeadm upgrade node
apt-get install kubelet=1.25.0-00 -y 
systemctl daemon-reload
systemctl restart kubelet

logout 

kubectl uncordon node01
kubectl get pods -o wide | grep gold

echo "#######################################################"

kubectl get nodes -o wide


