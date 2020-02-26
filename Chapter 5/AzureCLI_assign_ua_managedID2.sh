#!/bin/bash

# Assign a user-assigned managed identity to an existing Azure VM

# login to Azure 
az login

# Create a new user-assigned managed identity
az identity create \
    --resource-group MasteringAzureSecurity \
    --name myUserAssignedIdentity

# Assign the user-assigned managed identity to an existing VM
az vm identity assign \
    --resource-group MasteringAzureSecurity \
    --name myVM \
    --identities myUserAssignedIdentity