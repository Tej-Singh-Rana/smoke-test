#!/bin/bash

kubectl taint node node01 app_type=alpha:NoSchedule

cat <<EOF > /root/ques2.yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: alpha
  name: alpha
spec:
  tolerations:
  - effect: NoSchedule
    key: app_type
    value: alpha
  containers:
  - image: redis
    name: alpha
  dnsPolicy: ClusterFirst
  restartPolicy: Always

EOF

kubectl apply -f /root/ques2.yaml

