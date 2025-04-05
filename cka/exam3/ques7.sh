#!/bin/bash

kubectl delete pvc -n storage-ns app-pvc

cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-pvc
  namespace: storage-ns
spec:
  accessModes:
    - ReadWriteOnce        
  resources:
EOF

kubectl get pvc app-pvc -n storage-ns

kubectl get pv 
