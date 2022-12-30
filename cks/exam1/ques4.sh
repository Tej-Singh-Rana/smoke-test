#!/bin/bash

echo "Copying the audit.json seccomp profile to /var/lib/kubelet/seccomp/profiles" 

cat /root/CKS/audit.json

cp -vr /root/CKS/audit.json /var/lib/kubelet/seccomp/profiles


cat <<EOF > /root/ques4.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: audit-nginx
spec:
  securityContext:
    seccompProfile:
      type: Localhost
      localhostProfile: profiles/audit.json
  containers:
  - image: nginx
    name: nginx
EOF

kubectl apply -f /root/ques4.yaml

kubectl get po audit-nginx

