#!/bin/bash

kubectl get rs rs-d33393 -oyaml > /root/ques5.yaml

sed -i 's/busyboxXXXXXXX/busybox/g' /root/ques5.yaml

kubectl replace -f /root/ques5.yaml --force

