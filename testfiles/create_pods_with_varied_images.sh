#!/bin/bash

# List of different container images
IMAGES=("nginx" "httpd" "busybox" "alpine" "ubuntu" "redis" "mysql" "node" "python" "golang")

# Base name for pods
POD_BASE_NAME="varied-pod"

for i in "${!IMAGES[@]}"; do
  POD_NAME="${POD_BASE_NAME}-$((i+1))"
  IMAGE_NAME="${IMAGES[$i]}"

  echo "Creating pod: $POD_NAME with image: $IMAGE_NAME"

  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: $POD_NAME
spec:
  containers:
  - name: $POD_NAME-container
    image: $IMAGE_NAME
    command: ["/bin/sh", "-c", "sleep 3600"]
EOF

done

echo "All varied-image pods created."
