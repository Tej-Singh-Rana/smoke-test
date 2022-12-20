#!/bin/bash

cat <<EOF > /root/ques14.yaml
apiVersion: v1
kind: Pod
metadata:
  name: sega
spec:
  containers:
  - image: busybox
    name: tails
    command:
    - sleep
    - "3600"
  - image: nginx
    name: sonic
    env:
    - name: NGINX_PORT
      value: "8080"

EOF

kubectl create -f /root/ques14.yaml

