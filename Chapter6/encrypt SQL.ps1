$RGName = 'Packt-Encrypt'
$servername = 'packtSQL'
$DBName = 'test'
$cred = Get-Credential 

$RG = New-AzResourceGroup -Name $RGName -Location 'EastUS'

$server = Set-AzSqlServer -ResourceGroupName $RG.ResourceGroupName `
-ServerName $servername `
-AssignIdentity

$server = New-AzSqlServer -ResourceGroupName $RG.ResourceGroupName  `
-Location 'EastUS' `
-ServerName $server.ServerName `
-ServerVersion "12.0" `
-SqlAdministratorCredentials $cred `
-AssignIdentity

$database = New-AzSqlDatabase  -ResourceGroupName $RG.ResourceGroupName `
-ServerName $server.ServerName `
-DatabaseName $DBName `
-RequestedServiceObjectiveName "S0" `
-SampleName "AdventureWorksLT"

New-AzKeyvault -name 'Pact-KV-01' -ResourceGroupName $RG.ResourceGroupName`
-Location 'EastUS' `
-EnabledForDiskEncryption `
-EnabledForDiskEncryption `
-EnableSoftDelete `
-EnablePurgeProtection

$KeyVault = Get-AzKeyVault -VaultName 'Pact-KV-01' `
-ResourceGroupName $RG.ResourceGroupName

Set-AzKeyVaultAccessPolicy `
-VaultName $keyVault.VaultName `
-ObjectId $storageAccount.Identity.PrincipalId `
-PermissionsToKeys wrapkey,unwrapkey,get,recover

$key = Add-AzKeyVaultKey -VaultName $keyVault.VaultName `
-Name 'MyKey' `
-Destination 'Software'

Add-AzSqlServerKeyVaultKey -ResourceGroupName $RG.ResourceGroupName  `
-ServerName $server.ServerName `
-KeyId $key.Id

Set-AzSqlServerTransparentDataEncryptionProtector -ResourceGroupName $RG.ResourceGroupName  `
-ServerName $server.ServerName `
-Type AzureKeyVault `
-KeyId $key.Id

Get-AzSqlServerTransparentDataEncryptionProtector -ResourceGroupName $RG.ResourceGroupName  `
-ServerName $server.ServerName

Set-AzSqlDatabaseTransparentDataEncryption -ResourceGroupName -ResourceGroupName $RG.ResourceGroupName  `
-ServerName $server.ServerName `
-DatabaseName $database.DatabaseName `
-State "Enabled"