#!/bin/bash

kubectl create namespace dvl1987


cat <<EOF > /root/ques3-cm.yaml
---
apiVersion: v1
data:
  TIME_FREQ: "10"
kind: ConfigMap
metadata:
  name: time-config
  namespace: dvl1987
  
EOF

kubectl apply -f /root/ques3-cm.yaml

cat <<EOF > /root/ques3-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: time-check
  name: time-check
  namespace: dvl1987
spec:
  volumes:
  - name: log-volume
    emptyDir: {}
  containers:
  - image: busybox
    name: time-check
    env:
    - name: TIME_FREQ
      valueFrom:
            configMapKeyRef:
              name: time-config
              key: TIME_FREQ
    volumeMounts:
    - mountPath: /opt/time
      name: log-volume
    command:
    - "/bin/sh"
    - "-c"
    - "while true; do date; sleep $TIME_FREQ;done > /opt/time/time-check.log"
EOF

kubectl apply -f /root/ques3-pod.yaml 

