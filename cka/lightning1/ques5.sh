#!/bin/bash

cat <<EOF > /root/ques5-pvc.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-alpha-pvc
  namespace: alpha
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: slow

EOF

kubectl apply -f /root/ques5-pvc.yaml

