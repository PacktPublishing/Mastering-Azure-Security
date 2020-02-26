#!/bin/bash

# Disable system-assigned identity from an Azure VM

# login to Azure 
az login

# if you want to remove a system-assigned managed identity from a VM, but still need user-assigned identities, use the following command:
 az vm update 
    --name myVM \
    --resource-group MasteringAzureSecurity \
    --set identity.type='UserAssigned'

# If you have a virtual machine that no longer needs system-assigned identity and it has no user-assigned identities, use the following command:
az vm update 
    --name myVM \
    --resource-group MasteringAzureSecurity \
    --set identity.type="none"

# Tip: the value "none" is case-sensitive, so make sure to write it all lower case.