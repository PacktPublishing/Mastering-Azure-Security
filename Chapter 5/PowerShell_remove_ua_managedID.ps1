# Remove a user-assigned managed identity from an Azure VM

# login to Azure
Connect-AzAccount

# retrieve the VM configuration
$vm = Get-AzVM `
    -ResourceGroupName MasteringAzureSecurity `
    -Name myVM	

# If you want to remove all user-assigned managed identities but one, you can use the following command:
Update-AzVm `
    -ResourceGroupName MasteringAzureSecurity`
    -VM $vm`
    -IdentityType UserAssigned ``
    -IdentityID <USER ASSIGNED IDENTITY NAME>

# if you no longer need any managed identities, use the follwing command instead:
Update-AzVm `
    -ResourceGroupName MasteringAzureSecurity`
    -VM $vm`
    -IdentityType None