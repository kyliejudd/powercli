<#
.Synopsis
   Automation of adding virtual portgroups
.DESCRIPTION
   This script will allow you to add multiple port groups to multiple clusters.
   This will only work with clusters as adding porgroups to individual hosts is discouraged
   If the port groups exists on the host an error will be thrown and the script will continue.
.How to
   Before you run this script you will need to create/edit a CSV with the headers cluster,vswitch,VLANname,VLANid
   and each column to be filled with the required data, see template file.
   This will help to identify vlans networking views without the need to open the properties.
   There is a CSV you can edit in the location of this script.
   The vcenter server is already configured in the script as at the moment we only use one, you will be prompted for creds
   these are the same ones you use to connect to vcenter.
   You will be prompted to enter the full path of the CSV file for this script, this is done to remind users to check the CSV for the right information.
   
#>


# variable collection
Add-PSSnapin vmware* -WarningAction Ignore
$viserver = read-host "enter the FQDN of your vcenter" 
# connecting to vcenter
connect-viserver $viserver -WarningAction Ignore -Credential (Get-Credential)
Write-Host -BackgroundColor yellow -ForegroundColor black "Ensure you have the path to your CSV formatted correctly: cluster,vswitch,VLANname,VLANid. Also ensure the the VLANname has the vlan on the end i.e ESB_SB_FE_3154"
# State the path to the csv which holds your cluster, portgroup name, vlans
$InputFile = read-host "Enter the path to your CSV"
# import csv file
$VLANFile = Import-CSV $InputFile
# parse file into variables, each $VLAN.name refers to the column in your CSV
ForEach($VLAN in $VLANFile) {
    $Cluster = $VLAN.cluster
    $vSwitch = $VLAN.vSwitch
    $VLANname = $VLAN.VLANname
    $VLANid = $VLAN.VLANid
    # list the hosts in the clusters specified 
    $VMHosts = Get-Cluster $Cluster | Get-VMHost | sort Name | % {$_.Name}
    # Get the virtual switch from each host and set new port group with details from the variables.
        ForEach ($VMHost in $VMHosts) {
            Get-VirtualSwitch -VMHost $VMHost -Name $vSwitch | New-VirtualPortGroup -Name $VLANname -VLanId $VLANid
    }
}