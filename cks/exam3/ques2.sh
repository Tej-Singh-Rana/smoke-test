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

echo "##############################"

echo "
 - --audit-policy-file=/etc/kubernetes/prod-audit.yaml
 - --audit-log-path=/var/log/prod-secrets.log
 - --audit-log-maxage=30
 "
 
 echo "##############################"

echo "Add volumes in kube-apiserver.yaml file"

 echo "
   - name: audit
    hostPath:
      path: /etc/kubernetes/prod-audit.yaml
      type: File

  - name: audit-log
    hostPath:
      path: /var/log/prod-secrets.log
      type: FileOrCreate
"

echo "##############################"

echo "Add volumemounts in kube-apiserver.yaml file"

echo "
  - mountPath: /etc/kubernetes/prod-audit.yaml
    name: audit
    readOnly: true
  - mountPath: /var/log/prod-secrets.log
    name: audit-log
    readOnly: false
"




