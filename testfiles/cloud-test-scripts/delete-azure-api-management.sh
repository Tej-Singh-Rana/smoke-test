#!/bin/bash

# Set the resource group name
RESOURCE_GROUP=$(az group list --query "[0].name" -o tsv)

# List all API Management services in the resource group
APIM_SERVICES=$(az apim list --resource-group "$RESOURCE_GROUP" --query "[].name" -o tsv)

# Loop through the list of APIM services and delete each one by its name
for APIM_NAME in $APIM_SERVICES
do
  # Delete the API Management service
  az apim delete \
    --name "$APIM_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --yes --no-wait

  echo "Deleting API Management service: $APIM_NAME"
done
