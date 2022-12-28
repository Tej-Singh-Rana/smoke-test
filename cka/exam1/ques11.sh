#!/bin/bash


kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os_x43kj56.txt

sleep 2

cat /opt/outputs/nodes_os_x43kj56.txt


