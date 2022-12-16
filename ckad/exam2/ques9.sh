#!/bin/bash

cat <<EOF > /root/ques9.yaml
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: custom-volume
spec:
  accessModes: ["ReadWriteMany"]
  capacity:
    storage: 50Mi
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /opt/data
    
EOF

kubectl apply -f /root/ques9.yaml

