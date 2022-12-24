#!/bin/bash


kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > /root/CKA/node_ips

echo "Content of the node_ips file"

cat /root/CKA/node_ips

