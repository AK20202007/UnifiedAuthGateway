#!/bin/bash
# provision_azure_vm.sh
# Provisions an Ubuntu 22.04 LTS VM on Azure for the Unified Auth Gateway

set -e

RESOURCE_GROUP="UnifiedAuthGateway-RG"
LOCATION="eastus"
VM_NAME="auth-gateway-vm"
ADMIN_USER="ubuntu"

echo "Creating Resource Group: $RESOURCE_GROUP in $LOCATION..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Provisioning Ubuntu VM: $VM_NAME..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image Ubuntu2204 \
  --admin-username $ADMIN_USER \
  --generate-ssh-keys \
  --public-ip-sku Standard

echo "Opening Port 80 for HTTP Traffic..."
az vm open-port --port 80 --resource-group $RESOURCE_GROUP --name $VM_NAME

echo "=========================================================="
echo "VM Provisioning Complete!"
echo "Get your VM's public IP address using:"
echo "az vm show -d -g $RESOURCE_GROUP -n $VM_NAME --query publicIps -o tsv"
echo "Then SSH into it: ssh $ADMIN_USER@<IP_ADDRESS>"
echo "=========================================================="
