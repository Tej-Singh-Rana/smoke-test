#!/bin/bash

cat <<EOF > /root/ques5-beta-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: beta-pod
  namespace: beta
spec:
  containers:
  - image: kodekloud.io/google-samples/node-hello:1.0
    imagePullPolicy: IfNotPresent
    name: dev-pod
  dnsPolicy: ClusterFirst
  serviceAccount: default

EOF

kubectl apply -f /root/ques5-beta-pod.yaml

kubectl get po -n beta


