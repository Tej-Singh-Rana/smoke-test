#!/bin/bash

apparmor_parser -q /etc/apparmor.d/frontend  

cat <<EOF > /root/ques1.yaml
---
apiVersion: v1
kind: Pod
metadata:
  annotations:
    container.apparmor.security.beta.kubernetes.io/nginx: localhost/restricted-frontend #Apply profile 'restricted-fronend' on 'nginx' container
  labels:
    run: nginx
  name: frontend-site
  namespace: omni
spec:
  serviceAccount: frontend-default #Use the service account with least privileges
  containers:
  - image: nginx:alpine
    name: nginx
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: test-volume
  volumes:
  - name: test-volume
    hostPath:
      path: /data/pages
      type: Directory
EOF

kubectl replace -f /root/ques1.yaml --force

echo " "
echo "#########################################"
echo " "

kubectl -n omni delete sa frontend

kubectl -n omni delete sa fe

