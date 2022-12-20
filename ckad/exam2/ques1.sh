#!/bin/bash

cat <<EOF > /root/ques1-deploy.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    tier: frontend
    app: my-webapp
  name: my-webapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-webapp
  template:
    metadata:
      labels:
        app: my-webapp
    spec:
      containers:
      - image: nginx
        name: nginx
EOF

kubectl apply -f /root/ques1-deploy.yaml

cat <<EOF > /root/ques1-svc.yaml
---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: my-webapp
    tier: frontend
  name: front-end-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 30083
  selector:
    app: my-webapp
  type: NodePort

EOF

kubectl apply -f /root/ques1-svc.yaml
