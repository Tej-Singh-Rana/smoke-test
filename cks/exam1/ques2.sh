#!/bin/bash

mkdir -p /root/CKS/secrets/

echo "Check the status of the nodes and pods"

kubectl get nodes 
kubectl get pods -A

echo " "
sleep 1

kubectl -n orion get secrets a-safe-secret -o jsonpath='{.data.CONNECTOR_PASSWORD}' | base64 --decode >/root/CKS/secrets/CONNECTOR_PASSWORD

cat <<EOF > /root/ques2.yaml
---
apiVersion: v1
kind: Pod
metadata:
    labels:
        name: app-xyz
    name: app-xyz
    namespace: orion
spec:
    containers:
     -
       image: nginx
       name: app-xyz
       ports:
       - containerPort: 3306
       volumeMounts:
       - name: secret-volume
         mountPath: /mnt/connector/password
         readOnly: true
    volumes:
    - name: secret-volume
      secret:
        secretName: a-safe-secret

EOF

kubectl replace -f /root/ques2.yaml --force

sleep 2

kubectl get po -n orion

