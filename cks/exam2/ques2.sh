#!/bin/bash

cat <<EOF > /root/ques2-netpol.yaml
---
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-app1-app2
  namespace: apps-xyz
spec:
  podSelector:
    matchLabels:
      tier: backend
      role: db
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: app1
          tier: frontend
    - podSelector:
        matchLabels:
          name: app2
          tier: frontend

EOF

kubectl apply -f /root/ques2-netpol.yaml


kubectl get po,netpol -n apps-xyz


