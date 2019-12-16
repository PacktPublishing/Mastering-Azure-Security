$FWsub = New-AzVirtualNetworkSubnetConfig -Name AzureFirewallSubnet -AddressPrefix 10.0.1.0/26
$Worksub = New-AzVirtualNetworkSubnetConfig -Name Workload-SN -AddressPrefix 10.0.2.0/24
$Jumpsub = New-AzVirtualNetworkSubnetConfig -Name Jump-SN -AddressPrefix 10.0.3.0/24
$testVnet = New-AzVirtualNetwork -Name Packt-VNet -ResourceGroupName Packt-Security -Location "westeurope" -AddressPrefix 10.0.0.0/16 -Subnet $FWsub, $Worksub, $Jumpsub

New-AzVm -ResourceGroupName Packt-Security -Name "Srv-Jump" -Location "westeurope" -VirtualNetworkName Packt-VNet -SubnetName Jump-SN -OpenPorts 3389 -Size "Standard_DS2"


$NIC = New-AzNetworkInterface -Name Srv-work -ResourceGroupName Packt-Security -Location "westeurope" -Subnetid $testVnet.Subnets[1].Id
$VirtualMachine = New-AzVMConfig -VMName Srv-Work -VMSize "Standard_DS2"
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName Srv-Work -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2016-Datacenter' -Version latest
New-AzVM -ResourceGroupName Packt-Security -Location "westeurope" -VM $VirtualMachine -Verbose


$FWpip = New-AzPublicIpAddress -Name "fw-pip" -ResourceGroupName Packt-Security -Location "westeurope" -AllocationMethod Static -Sku Standard
$Azfw = New-AzFirewall -Name Test-FW01 -ResourceGroupName Packt-Security -Location "westeurope" -VirtualNetworkName Packt-VNet -PublicIpName fw-pip
$AzfwPrivateIP = $Azfw.IpConfigurations.privateipaddress
$AzfwPrivateIP



$routeTableDG = New-AzRouteTable -Name Firewall-rt-table -ResourceGroupName Packt-Security -location "westeurope" -DisableBgpRoutePropagation
Add-AzRouteConfig -Name "DG-Route" -RouteTable $routeTableDG -AddressPrefix 0.0.0.0/0 -NextHopType "VirtualAppliance" -NextHopIpAddress $AzfwPrivateIP | Set-AzRouteTable
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $testVnet -Name Workload-SN -AddressPrefix 10.0.2.0/24 -RouteTable $routeTableDG | Set-AzVirtualNetwork

$AppRule1 = New-AzFirewallApplicationRule -Name Allow-Google -SourceAddress 10.0.2.0/24 -Protocol http, https -TargetFqdn www.google.com
$AppRuleCollection = New-AzFirewallApplicationRuleCollection -Name App-Coll01 -Priority 200 -ActionType Allow -Rule $AppRule1
$Azfw.ApplicationRuleCollections = $AppRuleCollection
Set-AzFirewall -AzureFirewall $Azfw

$NetRule1 = New-AzFirewallNetworkRule -Name "Allow-DNS" -Protocol UDP -SourceAddress 10.0.2.0/24 -DestinationAddress 209.244.0.3,209.244.0.4 -DestinationPort 53
$NetRuleCollection = New-AzFirewallNetworkRuleCollection -Name RCNet01 -Priority 200 -Rule $NetRule1 -ActionType "Allow"
$Azfw.NetworkRuleCollections = $NetRuleCollection
Set-AzFirewall -AzureFirewall $Azfw

$NIC.DnsSettings.DnsServers.Add("209.244.0.3")
$NIC.DnsSettings.DnsServers.Add("209.244.0.4")
$NIC | Set-AzNetworkInterface
