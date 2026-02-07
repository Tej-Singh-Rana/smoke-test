#!/usr/bin/env bash

resource_group=$(az group list --query "[0].name" -o tsv)

regions=(
  "westus"
  "eastus"
  "centralus"
  "southcentralus"
)

total_acr=5

for i in $(seq 1 $total_acr); do
  # Pick region in round-robin order
  region_index=$(( (i - 1) % ${#regions[@]} ))
  region=${regions[$region_index]}

  # Make globally unique name
  acr_name="acr${region//-/}$(openssl rand -hex 3)"

  echo "Creating ACR: $acr_name in $region..."

  az acr create \
    --resource-group "$resource_group" \
    --name "$acr_name" \
    --location "$region" \
    --sku Basic
done
