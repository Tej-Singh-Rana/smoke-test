#!/bin/bash

cat <<EOF > /root/ques9.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: orange
  namespace: default
spec:
  containers:
  - command:
    - sh
    - -c
    - echo The app is running! && sleep 3600
    image: busybox:1.28
    imagePullPolicy: IfNotPresent
    name: orange-container
    resources: {}
  initContainers:
  - command:
    - sh
    - -c
    - sleep 2;
    image: busybox
    imagePullPolicy: Always
    name: init-myservice

EOF


kubectl replace -f /root/ques9.yaml --force

sleep 2

kubectl get po orange 

