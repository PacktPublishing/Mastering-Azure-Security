#!/bin/bash

# Enable system-assigned managed identity during creation of an Azure VM

# login to Azure 
az login

# create a new resource group
az group create \
    --name MasteringAzureSecurity \
    --location westus

# create a new VM in the new resource group and assign a system-assigned managed ID
az vm create \
    --resource-group MasteringAzureSecurity \
    --name myVM \
    --image win2016datacenter \
    --generate-ssh-keys \
    --assign-identity \
    --admin-username azureuser \
    --admin-password yourPassword123