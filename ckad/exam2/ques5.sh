#!/bin/bash


cat <<EOF > /root/ques5.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: pod-with-rprobe
  name: pod-with-rprobe
  namespace: default
spec:
  containers:
  - env:
    - name: APP_START_DELAY
      value: "180"
    image: kodekloud/webapp-delayed-start
    imagePullPolicy: Always
    name: pod-with-rprobe
    ports:
    - containerPort: 8080
      protocol: TCP
    readinessProbe: 
      httpGet:
        path: /ready
        port: 8080

EOF

kubectl replace -f /root/ques5.yaml --force

