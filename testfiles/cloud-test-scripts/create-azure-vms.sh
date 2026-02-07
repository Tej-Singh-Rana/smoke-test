#!/bin/bash

resource_group=$(az group list --query "[0].name" -o tsv)

# Regions
regions=(
  "westus"
  "eastus"
  "centralus"
  "southcentralus"
)

# VM Sizes
vm_sizes=(
  "Standard_D2s_v3"
  "Standard_B2s"
  "Standard_B1s"
  "Standard_DS1_v2"
)

for i in {1..8}; do
  az vm create \
    --resource-group "$resource_group" \
    --name myvm$i \
    --image Ubuntu2204 \
    --size Standard_B2s \
    --os-disk-size-gb 128 \
    --storage-sku Standard_LRS \
    --admin-username azureuser \
    --generate-ssh-keys
done

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

for region in "${regions[@]}"; do
  echo "Creating VMs in region: $region ..."
  
  for size in "${vm_sizes[@]}"; do
    for i in {1..8}; do
      vm_name="vm-${region}-${size//_/}-${i}"
      echo "  -> Creating VM: $vm_name (Size: $size)"

      az vm create \
        --resource-group "$resource_group" \
        --name "$vm_name" \
        --location "$region" \
        --image Ubuntu2204 \
        --size "$size" \
        --os-disk-size-gb 128 \
        --storage-sku Standard_LRS \
        --admin-username azureuser \
        --generate-ssh-keys
    done
  done
done

echo "VM creation completed successfully."
