#!/bin/bash

# Enable system-assigned managed identity on an existing Azure VM

# login to Azure 
az login

# assign a system-assigned managed identity
az vm identity assign \
    --resource-group MasteringAzureSecurity \
    --name myVm