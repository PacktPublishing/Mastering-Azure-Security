#!/bin/bash

# Assign a user-assigned managed identity during the creation of an Azure VM

# login to Azure 
az login

# create a new resource group
az group create \
    --name MasteringAzureSecurity \
    --location westus

# Create a new user-assigned managed identity
az identity create \
    --resource-group MasteringAzureSecurity \
    --name <USER ASSIGNED IDENTITY NAME>

# create a new VM in the new resource group and assign a system-assigned managed ID
az vm create \
    --resource-group MasteringAzureSecurity \
    --name myVM \
    --image UbuntuLTS \
    --assign-identity <USER ASSIGNED IDENTITY NAME> \
    --admin-username azureuser \
    --admin-password myPassword123