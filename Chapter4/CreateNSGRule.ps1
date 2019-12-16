New-AzResourceGroup -Name "Packt-Security" -Location "westeurope"

New-AzVirtualNetwork -Name "Packt-VNet" -ResourceGroupName "Packt-Security"  -Location  "westeurope" -AddressPrefix 10.11.0.0/16

New-AzNetworkSecurityGroup -Name "nsg1" -ResourceGroupName "Packt-Security"  -Location  "westeurope"

$nsg=Get-AzNetworkSecurityGroup -Name 'nsg1' -ResourceGroupName 'Packt-Security'
$nsg | Add-AzNetworkSecurityRuleConfig -Name 'Allow_HTTPS' -Description 'Allow_HTTPS' -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 443 | Set-AzNetworkSecurityGroup
$nsg | Add-AzNetworkSecurityRuleConfig -Name 'Allow_SSH' -Description 'Allow_SSH' -Access Allow -Protocol Tcp -Direction Outbound -Priority 100 -SourceAddressPrefix VirtualNetwork  -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 | Set-AzNetworkSecurityGroup

$vnet = Get-AzVirtualNetwork -Name 'Packt-VNet' -ResourceGroupName 'Packt-Security'
Add-AzVirtualNetworkSubnetConfig -Name FrontEnd -AddressPrefix 10.11.0.0/24 -VirtualNetwork $vnet
$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name FrontEnd
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName 'Packt-Security' -Name 'nsg1'
$subnet.NetworkSecurityGroup = $nsg
Set-AzVirtualNetwork -VirtualNetwork $vnet 
