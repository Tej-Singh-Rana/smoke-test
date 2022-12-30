#!/bin/bash


cat <<EOF > /root/ques7.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
   run: busy-rx100
  name: busy-rx100
  namespace: production
spec:
  runtimeClassName: gvisor
  containers:
  - image: nginx
    name: busy-rx100

EOF

kubectl replace -f /root/ques7.yaml --force

kubectl get po -n production

