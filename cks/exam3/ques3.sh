#!/bin/bash


sed -i 's/privileged: true/privileged: false/g' /root/kubesec-pod.yaml

echo " "
echo "##############################"
echo " "

kubesec scan /root/kubesec-pod.yaml | head -n15


kubesec scan /root/kubesec-pod.yaml > /root/kubesec_success_report.json

