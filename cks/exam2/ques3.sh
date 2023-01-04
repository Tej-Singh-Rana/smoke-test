#!/bin/bash

cat <<EOF > /root/ques3-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: apps-cluster-dash
  name: apps-cluster-dash
  namespace: gamma
spec:
  containers:
  - image: nginx
    name: apps-cluster-dash
  serviceAccountName: cluster-view
  automountServiceAccountToken: false
  
EOF

kubectl replace -f /root/ques3-pod.yaml --force

kubectl get po -n gamma

