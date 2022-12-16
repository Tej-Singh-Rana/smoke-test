#!/bin/bash


cat <<EOF > /root/ques4-pvc.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
       storage: 10Mi

EOF

cat <<EOF > /root/ques4-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: use-pv
  name: use-pv
spec:
  containers:
  - image: nginx
    name: use-pv
    volumeMounts:
    - mountPath: "/data"
      name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: my-pvc

EOF

kubectl apply -f /root/ques4-pvc.yaml

kubectl apply -f /root/ques4-pod.yaml



