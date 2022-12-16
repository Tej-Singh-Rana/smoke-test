#!/bin/bash

cat <<EOF > /root/ques6-csr.yaml
---
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john-developer
spec:
  signerName: kubernetes.io/kube-apiserver-client
  request: $(cat /root/CKA/john.csr)
  usages:
  - digital signature
  - key encipherment
  - client auth

EOF

kubectl apply -f /root/ques6-csr.yaml

echo "Approving the certificate"
kubectl certificate approve john-developer

echo "Creating role and rolebinding"
kubectl create role developer --resource=pods --verb=create,list,get,update,delete --namespace=development
kubectl create rolebinding developer-role-binding --role=developer --user=john --namespace=development

echo "To test the permissions"
kubectl auth can-i update pods --as=john --namespace=development
