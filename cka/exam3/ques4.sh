#!/bin/bash


cat <<EOF > /root/ques4.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: non-root-pod
spec:
  securityContext:
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - name: non-root-pod
    image: redis:alpine

EOF

kubectl apply -f /root/ques4.yaml

sleep 2

kubectl exec -it non-root-pod -- id

