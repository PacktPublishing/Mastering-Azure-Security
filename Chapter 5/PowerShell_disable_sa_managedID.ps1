# Disable system-assigned managed identity from an Azure VM

# login to Azure
Connect-AzAccount

# retrieve the VM configuration
$vm = Get-AzVM `
    -ResourceGroupName MasteringAzureSecurity `
    -Name myVM	

# change the identity type to user-assigned
Update-AzVm `
    -ResourceGroupName MasteringAzureSecurity`
    -VM $vm`
    -IdentityType "UserAssigned"

# if you no longer need any managed identity, use the follwing command instead:
Update-AzVm `
    -ResourceGroupName MasteringAzureSecurity`
    -VM $vm`
    -IdentityType None