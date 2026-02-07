#!/bin/bash

for i in {1..8}; do
  az vm create \
    --resource-group kml_rg_dev-139f9ad3abe04f88 \
    --name myvm$i \
    --image Ubuntu2204 \
    --size Standard_B2s \
    --os-disk-size-gb 128 \
    --storage-sku Standard_LRS \
    --admin-username azureuser \
    --generate-ssh-keys
done


echo "Successfully created 8 Azure VMs."

resource_group=$(az group list --query "[0].name" -o tsv)

regions=(
  "westus"
  "eastus"
  "centralus"
  "southcentralus"
)

for region in "${regions[@]}"; do
  echo "Creating VMs in region: $region ..."
  for i in {1..3}; do
    vm_name="vm-${region}-${i}"
    echo "  -> Creating VM: $vm_name"

    az vm create \
      --resource-group "$resource_group" \
      --name "$vm_name" \
      --location "$region" \
      --image Ubuntu2204 \
      --size Standard_B2s \
      --os-disk-size-gb 128 \
      --storage-sku Standard_LRS \
      --admin-username azureuser \
      --generate-ssh-keys
  done
done

