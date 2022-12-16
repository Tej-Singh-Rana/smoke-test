#!/bin/bash

kubectl taint node node01 env_type=production:NoSchedule


kubectl run dev-redis --image=redis:alpine


cat <<EOF > /root/ques6.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: prod-redis
spec:
  containers:
  - name: prod-redis
    image: redis:alpine
  tolerations:
  - effect: NoSchedule
    key: env_type
    operator: Equal
    value: production  

EOF

kubectl apply -f /root/ques6.yaml

kubectl get po -owide

