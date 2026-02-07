#!/bin/bash

# Set the resource group name
RESOURCE_GROUP=$(az group list --query "[0].name" -o tsv)

# Get a list of all container instances in the resource group
CONTAINER_INSTANCES=$(az container list --resource-group "$RESOURCE_GROUP" --query "[].name" -o tsv)

# Loop through the container instances and delete them
for CONTAINER_NAME in $CONTAINER_INSTANCES
do
  # Delete the container instance
  az container delete --name "$CONTAINER_NAME" --resource-group "$RESOURCE_GROUP" --yes
  
  echo "Deleted container instance: $CONTAINER_NAME"
done
