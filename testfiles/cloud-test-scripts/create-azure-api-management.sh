#!/bin/bash

# Set the resource group name
RESOURCE_GROUP=$(az group list --query "[0].name" -o tsv)

# List of regions
REGIONS=("West US" "East US" "Central US" "South Central US")

# Loop to create 10 API Management services in each region
for region in "${REGIONS[@]}"
do
  for i in {1..10}
  do
    # Replace spaces with hyphens in region name
    REGION_NAME=$(echo $region | sed 's/ /-/g')
    
    # Set unique names, publisher email, and publisher name for each APIM service
    APIM_NAME="testor2026-${REGION_NAME}-$i"
    PUBLISHER_EMAIL="newemail${REGION_NAME}$i@example.com"
    PUBLISHER_NAME="New Admin $region $i"

    # Create the API Management service in the specific region
    az apim create \
      --name "$APIM_NAME" \
      --resource-group "$RESOURCE_GROUP" \
      --location "$region" \
      --sku-name "Basic" \
      --sku-capacity 2 \
      --publisher-email "$PUBLISHER_EMAIL" \
      --publisher-name "$PUBLISHER_NAME" \
      --enable-client-certificate true

    echo "API Management service $APIM_NAME created in $region."
  done
done
