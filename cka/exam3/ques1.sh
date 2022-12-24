#!/bin/bash

kubectl create serviceaccount pvviewer

kubectl create clusterrole pvviewer-role --resource=persistentvolumes --verb=list

kubectl create clusterrolebinding pvviewer-role-binding --clusterrole=pvviewer-role --serviceaccount=default:pvviewer


cat <<EOF > /root/ques1.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pvviewer
  name: pvviewer
spec:
  containers:
  - image: redis
    name: pvviewer
  # Add service account name
  serviceAccountName: pvviewer

EOF

kubectl apply -f /root/ques1.yaml 

echo "Status of the created pod and serviceaccount"

kubectl get po,sa

