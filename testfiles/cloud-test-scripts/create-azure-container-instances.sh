#!/bin/bash

# Set the base image and resource group
IMAGE="demo.goharbor.io/docker/grafana/grafana"
RESOURCE_GROUP=$(az group list --query "[0].name" -o tsv)
CPU_CONFIGS=("0.25" "0.5" "0.75" "1" "1.25" "1.5" "1.75" "2")
MEMORY_CONFIGS=("1" "1.5" "2" "2.5" "3" "4")
OS_TYPES=("Linux" "Windows")
REGIONS=("West US" "East US" "Central US" "South Central US")

# Loop to create 100 container instances in each region with different configurations
for i in {1..100}
do
  # Generate a unique name for each container
  CONTAINER_NAME="container$i"
  
  # Randomly pick CPU, memory, and OS type
  CPU="${CPU_CONFIGS[$RANDOM % ${#CPU_CONFIGS[@]}]}"
  MEMORY="${MEMORY_CONFIGS[$RANDOM % ${#MEMORY_CONFIGS[@]}]}"
  OS_TYPE="${OS_TYPES[$RANDOM % ${#OS_TYPES[@]}]}"
  
  # Randomly pick a region from the list
  REGION="${REGIONS[$RANDOM % ${#REGIONS[@]}]}"

  # Create the container instance in the selected region
  az container create \
    --name "$CONTAINER_NAME" \
    --image "$IMAGE" \
    --resource-group "$RESOURCE_GROUP" \
    --cpu "$CPU" \
    --memory "$MEMORY" \
    --os-type "$OS_TYPE" \
    --restart-policy OnFailure \
    --sku Standard \
    --location "$REGION"
  
  echo "Created container: $CONTAINER_NAME with CPU: $CPU, Memory: $MEMORY, OS Type: $OS_TYPE in Region: $REGION"
done
