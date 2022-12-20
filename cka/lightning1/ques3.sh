#!/bin/bash

sed -i 's/4380/6443/g' /root/CKA/admin.kubeconfig

echo "Output"
kubectl cluster-info --kubeconfig /root/CKA/admin.kubeconfig


