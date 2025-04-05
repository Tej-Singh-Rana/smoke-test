#!/bin/bash

kubectl delete po -n default orange --force

cat <<EOF | kubectl apply -f - 
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
  initContainers:
  - command:
    - sh
    - -c
    - sleep 2;
    image: busybox
    imagePullPolicy: Always
    name: init-myservice
EOF

kubectl get pod orange

