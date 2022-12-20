#!/bin/bash

cat <<EOF > /root/ques12.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-analytics
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteMany
  hostPath:
      path: /pv/data-analytics
      
EOF

kubectl create -f /root/ques12.yaml 


