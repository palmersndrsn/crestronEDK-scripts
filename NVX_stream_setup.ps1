<#

    2. Update the devices-ip.csv file as required, order is important.
    3. The device with the LAN connection must be last.
#>

# minimum required version
#Requires -Version 3
Set-StrictMode -Version Latest

# import the module
Import-Module PSCrestron

# get the device list
Write-Host 'Getting the device list...'
$devs = Import-Csv (Join-Path $PSScriptRoot 'devices-ip.csv')


# iterate the devices in order
foreach ($d in $devs)
{
    function Get-reboot_device
    {
        # reboot to complete
        Write-Host "rebooting $($d.Room_Name)..."
        Invoke-CrestronCommand -Device $d.Device -Command "reboot" -Timeout 20
    }
    # checks for device
    if($d.Device)
    {
        write-host "Beginning: $($d.device),$($d.Description),$($d.Room_Name)..."

        # checks if nvx
        if ($d.Description.StartsWith("DM-NVX")) {
            # $secure = "-Password admin -Secure -Username admin"
            if($d.IPID-and$d.processorIP-and$d.username-and$d.password)
            {
            }
        } else {
            write-host "description not found"
        }
        if($d.TX)
        {
            Invoke-CrestronCommand -Device $d.Device -Command 
        }
    }
}

Write-Host 'Done.'

Read-Host -Prompt “Press Enter to exit”