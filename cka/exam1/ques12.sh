#!/bin/bash

cat <<EOF > /root/ques12-pv.yaml
---
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

kubectl apply -f /root/ques12-pv.yaml

echo " "
echo "#####################################################"
echo " "

kubectl get pv

