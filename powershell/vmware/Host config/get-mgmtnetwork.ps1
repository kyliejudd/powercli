Get-VMHost * | Get-VMHostNetwork | Select Hostname, `
VMKernelGateway -ExpandProperty `
VirtualNic | Where {$_.ManagementTrafficEnabled} | Select Hostname, `
PortGroupName, IP, SubnetMask | sort IP | out-default