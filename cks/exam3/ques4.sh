#!/bin/bash

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: dev
  name: dev-write
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list", "create"]
EOF

kubectl create sa developer -n dev

cat <<EOF | kubectl apply -f -
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-write-binding
  namespace: dev
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: dev-write
subjects:
- kind: ServiceAccount
  name: developer
  namespace: dev
  
EOF

cat <<EOF > /root/ques4-dev-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: dev-pod
  namespace: dev
spec:
  containers:
  - image: gcr.io/google-samples/node-hello:1.0
    imagePullPolicy: IfNotPresent
    name: dev-pod
  dnsPolicy: ClusterFirst
  serviceAccount: developer

EOF

kubectl apply -f /root/ques4-dev-pod.yaml

