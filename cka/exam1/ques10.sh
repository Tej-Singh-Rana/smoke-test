#!/bin/bash

cat <<EOF > /root/ques10.yaml
---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: hr-web-app
  name: hr-web-app-service
spec:
  type: NodePort
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
    nodePort: 30082
  selector:
    app: hr-web-app

EOF

sleep 2

kubectl apply -f /root/ques10.yaml

sleep 2

kubectl get svc,ep,po,deploy -l app=hr-web-app

