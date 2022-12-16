#!/bin/bash

cat <<EOF > /root/ques1-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: log-volume
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  storageClassName: manual
  hostPath:
    path: /opt/volume/nginx

EOF

cat <<EOF > /root/ques1-pvc.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: log-claim
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 200Mi
  storageClassName: manual
  
  EOF
  
cat <<EOF > /root/ques1-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: logger
# pod name
  name: logger
spec:
  containers:
  - image: nginx:alpine
    name: logger
    volumeMounts:
    - name: log
      mountPath: /var/www/nginx
  volumes:
  - name: log
    persistentVolumeClaim:
        claimName: log-claim
EOF

kubectl create -f /root/ques1-pv.yaml 

kubectl create -f /root/ques1-pvc.yaml 

kubectl create -f /root/ques1-pod.yaml


