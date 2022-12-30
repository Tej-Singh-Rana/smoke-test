#!/bin/bash


cat <<EOF > /root/CKS/ImagePolicy/admission-configuration.yaml
---
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/admission-controllers/admission-kubeconfig.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: false

EOF

echo "#######################"

echo " Set the following parameter & plugin. 
- --admission-control-config-file=/etc/admission-controllers/admission-configuration.yaml
- --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
"
echo " "

cat <<EOF > /root/ques8-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: app-0403
  name: app-0403
  namespace: magnum
spec:
  containers:
  - args:
    - sleep
    - "2000"
    image: gcr.io/google-containers/busybox:1.27
    imagePullPolicy: Always
    name: app-0403

EOF

