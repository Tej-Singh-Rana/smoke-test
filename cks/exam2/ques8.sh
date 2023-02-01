#!/bin/bash

cat <<EOF > /root/CKS/simple-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
   labels:
    name: simple-webapp
   name: simple-webapp-1
spec:
  containers:
  - image: kodekloud/webapp-delayed-start
    name: simple-webapp
    ports:
    -
     containerPort: 8080
    securityContext:
      capabilities:
        add:
         - NET_ADMIN

EOF

kubesec scan /root/CKS/simple-pod.yaml | head -n10

kubesec scan /root/CKS/simple-pod.yaml > /root/CKS/kubesec-report.txt

