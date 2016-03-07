<#
.Synopsis
   Automation of adding virtual portgroups
.DESCRIPTION
   This script will allow you to add multiple port groups to multiple hosts.   
.How to
   Before you run this script you will need to create/edit a CSV with the headers vswitch,VLANname,VLANid
   and each column to be filled with the required data, see template file.
   You will be prompted to enter the full path of the CSV file for this script, this is done to remind users to check the CSV for the right information.
#>

$vchost = read-host "Enter the FQDN of your vcenter host"
$InputFile = read-host "Enter the path to your CSV"
Connect-VIServer $vchost -Credential (get-credential) -WarningAction SilentlyContinue
$vmhosts = read-host "which esxi host/s would you like to manage?"

# import csv file
$VLANFile = Import-CSV $InputFile
# parse file into variables, each $VLAN.name refers to the column in your CSV
# this will apply the port groups to each of the esxi hosts.
ForEach($VLAN in $VLANFile) {
    $vSwitch = $VLAN.vSwitch
    $VLANname = $VLAN.VLANname
    $VLANid = $VLAN.VLANid

# Get the virtual switch from each host and set new port group with details from the variables.
    ForEach ($VMHost in $VMHosts) {
        Get-VirtualSwitch -VMHost $VMHost -Name $vSwitch | New-VirtualPortGroup -Name $VLANname -VLanId $VLANid
    }
}