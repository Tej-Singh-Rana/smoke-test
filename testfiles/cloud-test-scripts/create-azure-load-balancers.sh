#!/usr/bin/env bash

resource_group=$(az group list --query "[0].name" -o tsv)

# 5 LBs total → distribution: 2 + 1 + 1 + 1
declare -A region_lb_count=(
  ["westus"]=2
  ["eastus"]=1
  ["centralus"]=1
  ["southcentralus"]=1
)

for region in "${!region_lb_count[@]}"; do
  count=${region_lb_count[$region]}

  echo "=== Region: $region | Creating $count Load Balancer(s) ==="

  for i in $(seq 1 $count); do
    lb_name="lb-${region}-${i}"
    pip_name="pip-${lb_name}"

    echo " -> Creating Public IP: $pip_name"
    az network public-ip create \
      --resource-group "$resource_group" \
      --name "$pip_name" \
      --location "$region" \
      --sku Standard

    echo " -> Creating Load Balancer: $lb_name"
    az network lb create \
      --resource-group "$resource_group" \
      --name "$lb_name" \
      --location "$region" \
      --sku Standard \
      --public-ip-address "$pip_name"
  done
done
