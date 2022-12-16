#!/bin/bash

cat <<EOF > /root/ques7.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2021-07-24T04:54:05Z"
  labels:
    name: webapp-color
  name: webapp-color
  namespace: default
spec:
  containers:
  - env:
    - name: APP_COLOR
      value: green
    image: kodekloud/webapp-color
    imagePullPolicy: Always
    name: webapp-color

EOF

kubectl replace -f /root/ques7.yaml --force

