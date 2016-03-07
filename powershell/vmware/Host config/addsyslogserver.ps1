# setting the syslog server destination and port, along with opening firewall ports.

$SysLogServer = "FQDN/IP"
$location = "clustername/datacenter/folder"

Get-VMHost -Location $location | Foreach {
    Write-Host "Adding $SysLogServer as Syslog server for $($_.Name)"
    $SetSyslog = Set-VMHostSysLogServer -SysLogServer $SysLogServer -SysLogServerPort 514 -VMHost $_
    Write-Host "Restarting Syslog on $($_.Name)"
    $Reload = (Get-ESXCLI -VMHost $_).System.Syslog.reload()
    Write-Host "Setting firewall to allow Syslog out of $($_)"
    $FW = $_ | Get-VMHostFirewallException | Where {$_.Name -eq 'syslog'} | Set-VMHostFirewallException -Enabled:$true
}