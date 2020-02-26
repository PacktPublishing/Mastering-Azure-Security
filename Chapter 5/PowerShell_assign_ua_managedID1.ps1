<# To assign a user-assigned managed identity during VM creation, you need to add the following code to your AzVmConfig:
    $vmConfig = New-AzVMConfig `
        -VMName <VM NAME> `
        -IdentityType UserAssigned `
        -IdentityID "/subscriptions/<SUBSCRIPTION ID>/resourcegroups/<RESROURCE GROUP>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<USER ASSIGNED IDENTITY NAME>..."
#>

# Assign a user-assigned managed identity to an existing Azure VM

# login to Azure
Connect-AzAccount

# Create a new user-assigned managed identity
New-AzUserAssignedIdentity `
    -ResourceGroupName MasteringAzureSecurity `
    -Name <USER ASSIGNED IDENTITY NAME>

    # retrieve the existing VM configuration
$vm = Get-AzVM `
    -ResourceGroupName MasteringAzureSecurity `
    -Name myVM

# update the VM configuration with the managed identity
Update-AzVM `
    -ResourceGroupName MasteringAzureSecurity `
    -VM $vm `
    -IdentityType UserAssigned `
    -IdentityID "/subscriptions/<SUBSCRIPTION ID>/resourcegroups/MasteringAzureSecurity/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<USER ASSIGNED IDENTITY NAME>"