#!/bin/bash

cat <<EOF > /root/ques5-role.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
    name: dev-user-access
    namespace: dev-z
rules:
  - apiGroups:
    - ""
    resources:
    - pods
    verbs:
    - get
    - list

EOF

kubectl create -f /root/ques5-role.yaml

kubectl get role dev-user-access -oyaml -n dev-z
