#!/bin/bash

set -e

# Array of images to use (can be repeated or extended)
images=(
  nginx
  httpd
  alpine
  busybox
  redis
  node
  python
  golang
  ubuntu
  debian
)

# Create 20 pods using different images (some repeated with version tags)
for i in $(seq 1 20); do
  image_index=$(( (i - 1) % ${#images[@]} ))
  image=${images[$image_index]}
  pod_name="pod-$i"

  echo "Creating pod $pod_name with image $image..."

  kubectl run "$pod_name" --image="$image" --restart=Never --command -- sleep 3600
done

echo "All 20 pods created."

cat <<EOF | kubectl apply -f -
---
apiVersion: apps/v1 
kind: Deployment
metadata:
  name: nginx
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx
  replicas: 2 
  template: 
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: default
  labels:
    app: nginx
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 32222
  selector:
    app: nginx
  type: NodePort 
EOF

kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml

kubectl wait --for=condition=Ready pod/dnsutils --timeout=60s

kubectl exec -i -t dnsutils -- nslookup kubernetes.default

kubectl exec -ti dnsutils -- cat /etc/resolv.conf

kubectl get pods --namespace=kube-system -l k8s-app=kube-dns

kubectl logs --namespace=kube-system -l k8s-app=kube-dns


