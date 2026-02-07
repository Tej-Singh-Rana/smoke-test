#!/usr/bin/env bash

# 🔧 Change this to your existing resource group
resource_group=$(az group list --query "[0].name" -o tsv)

regions=(
  "westus"
  "eastus"
  "centralus"
  "southcentralus"
)

# Simple address prefix base per region index
# 0 -> 10.0.0.0/16, 1 -> 10.1.0.0/16, etc.
i=0

for region in "${regions[@]}"; do
  echo "=== Region: $region ==="

  vnet_name="fw-vnet-$region"
  subnet_name="AzureFirewallSubnet"
  firewall_name="fw-$region"
  pip_name="pip-$firewall_name"

  # Calculate address space like 10.<i>.0.0/16 and subnet 10.<i>.0.0/24
  addr_octet=$i
  vnet_prefix="10.${addr_octet}.0.0/16"
  subnet_prefix="10.${addr_octet}.0.0/24"

  echo " -> Creating Public IP: $pip_name"
  az network public-ip create \
    --resource-group "$resource_group" \
    --name "$pip_name" \
    --location "$region" \
    --sku Standard

  echo " -> Creating VNet: $vnet_name with subnet $subnet_name"
  az network vnet create \
    --resource-group "$resource_group" \
    --name "$vnet_name" \
    --location "$region" \
    --address-prefix "$vnet_prefix" \
    --subnet-name "$subnet_name" \
    --subnet-prefix "$subnet_prefix"

  echo " -> Creating Azure Firewall: $firewall_name"
  az network firewall create \
    --resource-group "$resource_group" \
    --name "$firewall_name" \
    --location "$region" \
    --sku Basic

  echo " -> Configuring Firewall IP config"
  az network firewall ip-config create \
    --resource-group "$resource_group" \
    --firewall-name "$firewall_name" \
    --name "fw-ipconfig-$region" \
    --public-ip-address "$pip_name" \
    --vnet-name "$vnet_name"

  # Optional: show firewall IPs
  az network firewall show \
    --resource-group "$resource_group" \
    --name "$firewall_name" \
    --query "ipConfigurations[].privateIpAddress" \
    -o tsv

  i=$((i+1))
done
