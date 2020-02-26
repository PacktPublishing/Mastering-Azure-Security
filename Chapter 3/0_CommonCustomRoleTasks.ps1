#   Make sure you have the Az PowerShell module installed:
    install-module Az

#   Make sure you are connected to your Azure AD tenant
    Connect-AzAccount

#   List provider operations for an Azure resource provider
#   Get-AzProviderOperation <operation> | FT OperationName, Operation, Description -AutoSize
#   Example:
    Get-AzProviderOperation "Microsoft.Compute/virtualMachines/*" | Format-Table OperationName, Operation, Description -AutoSize

#   List role actions for a given role
#   (Get-AzRoleDefinition <role name>).Actions
#   Example:
    (Get-AzRoleDefinition "Virtual Machine Operator").Actions