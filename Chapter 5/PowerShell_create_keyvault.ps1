# Login to your Azure subscription
Login-AzAccount

# Define variable values
$rgName = "MasteringAzureSecurity"
$azRegion= “WestUS”
$kvName = “myAzKeyVault”
$secretName = “localAdmin”

# Create a new resource group in your Azure suscription
$resourceGroup = New-AzResourceGroup `
    -Name $rgName `
    -Location $azRegion

# Create the KeyVault
New-AzKeyVault `
	-VaultName $kvName `
	-ResourceGroupName $rgName `
	-Location $azRegion `
	-EnabledForDeployment `
	-EnabledForTemplateDeployment `
	-EnabledForDiskEncryption `
	-Sku standard

# Grant your user account access rights to Azure Key Vault secrets
Set-AzKeyVaultAccessPolicy `
	-VaultName $kvName `
	-ResourceGroupName $rgName `
	-UserPrincipalName (Get-AzContext).account.id `
	-PermissionsToSecrets get, set

# Create a new Azure Key Vault secret
$password = read-host -assecurestring
Set-AzKeyVaultSecret `
	-VaultName $kvName `
	-Name $secretName `
	-SecretValue $password