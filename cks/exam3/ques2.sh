#!/bin/bash

cat <<EOF > /etc/kubernetes/prod-audit.yaml
---
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  namespaces: ["prod"]
  verbs: ["delete"]
  resources:
  - group: ""
    resources: ["secrets"]

EOF

