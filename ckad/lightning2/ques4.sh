#!/bin/bash

cat <<EOF > /root/ques4.yaml
---
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: ingress-vh-routing
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: watch.ecom-store.com
    http:
      paths:
      - pathType: Prefix
        path: "/video"
        backend:
          service:
            name: video-service
            port:
              number: 8080
  - host: apparels.ecom-store.com
    http:
      paths:
      - pathType: Prefix
        path: "/wear"
        backend:
          service:
            name: apparels-service
            port:
              number: 8080

EOF

kubectl apply -f /root/ques4.yaml

