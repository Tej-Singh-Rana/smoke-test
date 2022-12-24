#!/bin/bash

cat /root/CKA/super.kubeconfig | grep server

sed -i 's/9999/6443/g' /root/CKA/super.kubeconfig

echo "#############################################"

echo "Port has changed!!" 

cat /root/CKA/super.kubeconfig | grep server

kubectl cluster-info --kubeconfig=/root/CKA/super.kubeconfig

