#!/bin/bash

kubectl delete pod lp-pod -n low-priority --force

cat <<EOF | kubectl apply -f -
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: low-priority
value: 50000
globalDefault: false
description: "Low priority class"
EOF

cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Pod
metadata:
  name: lp-pod
  namespace: low-priority
spec:
  priorityClassName: low-priority
  containers:
  - name: nginx
    image: nginx
EOF

kubectl get po,pc -n low-priority
