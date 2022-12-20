#!/bin/bash

cat <<EOF > /root/ques2.yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: secure-pod
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: webapp-color
    ports:
    - protocol: TCP
      port: 80

EOF

kubectl apply -f /root/ques2.yaml 

sleep 2

kubectl exec -it webapp-color -- nc -v -z -w 5 secure-service 80

