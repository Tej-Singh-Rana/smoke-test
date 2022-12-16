#!/bin/bash

cat <<EOF > /root/ques10.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-sec-kff3345
  namespace: default
spec:
  securityContext:
    runAsUser: 0
  containers:
  - command:
    - sleep
    - "4800"
    image: ubuntu
    name: ubuntu
    securityContext:
     capabilities:
        add: ["SYS_TIME"]
        
EOF

kubectl replace -f /root/ques10.yaml --force


