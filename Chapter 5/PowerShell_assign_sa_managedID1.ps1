# To assign a system-assigned managed identity during VM creation, you need to add the following code to your AzVmConfig:
# $vmConfig = New-AzVMConfig -VMName myVM -AssignIdentity:$SystemAssigned ...

# Assign a system-assigned managed identity to an existing VM

# login to Azure
Connect-AzAccount

# retrieve the existing VM configuration
$vm = Get-AzVM `
    -ResourceGroupName MasteringAzureSecurity `
    -Name myVM

# update the VM configuration with the managed identity
Update-AzVM `
    -ResourceGroupName MasteringAzureSecurity `
    -VM $vm `
    -AssignIdentity:$SystemAssigned