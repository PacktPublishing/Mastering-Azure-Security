New-AzResourceGroup -Name "Packt-Encrypt" -Location "EastUS"

$cred = Get-Credential 

New-AzVM -Name 'Packt-VM-01' `
-Credential $cred `
-ResourceGroupName 'Packt-Encrypt' `
-Image win2016datacenter `
-Size Standard_D2S_V3

New-AzKeyvault -name 'Pact-KV-01' `
-ResourceGroupName 'Packt-Encrypt' `
-Location EastUS `
-EnabledForDiskEncryption `
-EnableSoftDelete `
-EnablePurgeProtection

$KeyVault = Get-AzKeyVault -VaultName 'Pact-KV-01' -ResourceGroupName 'Packt-Encrypt'

Set-AzVMDiskEncryptionExtension -ResourceGroupName 'Packt-Encrypt' `
-VMName 'Packt-VM-01' `
-DiskEncryptionKeyVaultUrl $KeyVault.VaultUri `
-DiskEncryptionKeyVaultId $KeyVault.ResourceId

Get-AzVmDiskEncryptionStatus -VMName Packt-VM-01 -ResourceGroupName Packt-Encrypt
