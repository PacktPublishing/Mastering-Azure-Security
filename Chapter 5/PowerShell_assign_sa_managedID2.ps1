# Add VM system assigned identity to a group

# login to Azure
Connect-AzAccount

# retrieve and note the objectID of the service principal
Get-AzADServicePrincipal -displayname "myVM"

# retrieve and note the objectID of the group
Get-AzADGroup -searchstring "myGroup"

# add the VM's service principal to the group
Add-AzureADGroupMember `
    -ObjectId "<objectID of group>" `
    -RefObjectId "<object id of VM service principal>"