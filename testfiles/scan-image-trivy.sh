#!/bin/bash

# List of Docker images to scan
IMAGES=(
    "docker.io/kodekloud/webapp-delayed-start:latest"
    "docker.io/library/httpd:2-alpine"
    "docker.io/library/nginx:1.16"
    "docker.io/library/httpd:2.4.33"
)

# Number of times to run the command
RUNS=30

# Loop through each image
for ((i = 1; i <= RUNS; i++)); do
    echo "Run #$i"
    for IMAGE in "${IMAGES[@]}"; do
        echo "Scanning image: $IMAGE"
        trivy image "$IMAGE"
    done
done
