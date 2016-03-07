$vmhost = Read-Host "Enter the name of the host you want to copy"
$vswitch = Read-Host "enter the name of the vswitch to copy"
$vmhostdest = Read-Host "enter the name of the host you want to copy to"
$vswitchdest = Read-Host "enter the name of the vswitch you want to copy to"

$vmhostport = (Get-VMHost $vmhost | Get-VirtualSwitch -Name $vswitch | Get-VirtualPortGroup  | select `
Name,Virtualswitch,vlanid  | sort `
virtualswitch,name | ConvertTo-Csv -NoTypeInformation) 

foreach ($port in $vmhostport) {
$vswitch = $port.Virtualswitch
$portgroup = $port.Name
$vlanID = $port.VLanId



Get-VirtualSwitch -VMHost $vmhostdest -Name $vswitchdest | New-VirtualPortGroup `
-Name $portgroup -VLanId $vlanID

}



