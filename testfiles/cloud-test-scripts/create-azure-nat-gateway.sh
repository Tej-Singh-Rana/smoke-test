#!/usr/bin/env bash

resource_group=$(az group list --query "[0].name" -o tsv)

regions=(
  "westus"
  "eastus"
  "centralus"
  "southcentralus"
)

# 8 NAT gateways total → 2 per region
nat_per_region=2

for region in "${regions[@]}"; do
  echo "=== Region: $region ==="

  for i in $(seq 1 $nat_per_region); do
    nat_name="nat-${region}-${i}"
    public_ip_name="pip-${nat_name}"

    echo " -> Creating Public IP: $public_ip_name"
    az network public-ip create \
      --resource-group "$resource_group" \
      --name "$public_ip_name" \
      --location "$region" \
      --sku Standard

    echo " -> Creating NAT Gateway: $nat_name"
    az network nat gateway create \
      --resource-group "$resource_group" \
      --name "$nat_name" \
      --location "$region" \
      --public-ip-addresses "$public_ip_name"
      # NOTE: No --sku flag here
  done
done
