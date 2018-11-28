<#
    1. Put the zip firmware file in the same file as this NVX_FW_LOAD.ps1
    2. Make sure you run auto discovery first and all the device you want to update are there
    3. Run this and check back in 30 minutes
#>

# minimum required version
#Requires -Version 4
Set-StrictMode -Version Latest

# import the module
Import-Module PSCrestron

# auto discover the devices in the subnet
Write-Host 'Running Auto-Discovery...'
$devs = Get-AutoDiscovery |
    Where-Object Description -Match 'NVX' |
    Select-Object -ExpandProperty IP |
    Get-VersionInfo -Secure -Username admin -Password admin |
    Where-Object MACAddress -Match '[A-F\d\.]+' 

# firmware file
# $fw = Get-ChildItem -Path $PSScriptRoot -Filter *.zip
# $fw = "C:\Users\p_sanderson\Downloads\dm-nvx-350_dm-nvx-350c_dm-nvx-351_dm-nvx-351c_1.3707.00028.zip"


# start the jobs
write-host 'starting script block'
$password = "coitcom" #need to ask user in console window
$devs | Invoke-RunspaceJob -SharedVariables password -ScriptBlock {
    write-host 'in script block sending fw'
    # need to check if its $_ or $_.IPAddress that worked.
    Invoke-CrestronCommand -Device $_.IPAddress -Command "RESETP -N:admin -P:$($password)" -Password admin -Secure -Username admin
}

Write-Host 'Done.'

Read-Host -Prompt “Press Enter to exit”
