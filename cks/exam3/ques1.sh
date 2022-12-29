#!/bin/bash



sed -i 's/AlwaysAllow/Webhook/g' /var/lib/kubelet/config.yaml

echo "protectKernelDefaults: true" >> /var/lib/kubelet/config.yaml

sleep 1

cat /var/lib/kubelet/config.yaml | grep mode

echo " " 

cat /var/lib/kubelet/config.yaml | tail -n 3

