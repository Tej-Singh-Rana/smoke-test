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
