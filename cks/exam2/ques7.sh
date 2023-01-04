#!/bin/bash

cp -vr ./custom-profile.json /var/lib/kubelet/seccomp/custom-profile.json

cat <<EOF > /root/ques7-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
    labels:
      app: omega-app
    name: omega-app
    namespace: omega
spec:
    containers:
    - args:
      - -text=just made some syscalls!
      image: hashicorp/http-echo:0.2.3
      imagePullPolicy: IfNotPresent
      name: test-container
      resources: {}
      securityContext:
        allowPrivilegeEscalation: false
    dnsPolicy: ClusterFirst
    enableServiceLinks: true
    preemptionPolicy: PreemptLowerPriority
    priority: 0
    restartPolicy: Always
    schedulerName: default-scheduler
    securityContext:
      seccompProfile:
        localhostProfile: custom-profile.json
        type: Localhost
    serviceAccount: default
    serviceAccountName: default

EOF

kubectl replace -f /root/ques7-pod.yaml --force

kubectl get po -n omega

echo "#####################################################"
echo " "

echo "Expected output should be write and read" 

cat /var/lib/kubelet/seccomp/custom-profile.json | jq -r '.syscalls[].names[]' | grep -w write

cat /var/lib/kubelet/seccomp/custom-profile.json | jq -r '.syscalls[].names[]' | grep -w read

echo " "

kubectl get po -n omega


