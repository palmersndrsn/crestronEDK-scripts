
# ---------------------------------------------------------

<#

    2. Update the devices-ip.csv file as required, order is important.
    3. The device with the LAN connection must be last.
    
#>

# minimum required version
#Requires -Version 3
Set-StrictMode -Version Latest

# import the module
Import-Module PSCrestron

$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)

Get-AutoDiscovery | export-csv $DesktopPath"\auto_discovery_results.csv"

Write-Host 'Done.'

Read-Host -Prompt “Press Enter to exit”