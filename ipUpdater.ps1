<#

    2. Update the devices-ip.csv file as required, order is important.
    3. The device with the LAN connection must be last.
#>

# minimum required version
#Requires -Version 3
Set-StrictMode -Version Latest

# import the module
Import-Module PSCrestron

# build configs
Write-Host "building avaliable configs..."
py "C:\Users\p_sanderson\Documents\Python_Scripts\config_file_editor.py"\

# get the device list
Write-Host 'Getting the device list...'
$devs = Import-Csv (Join-Path $PSScriptRoot 'devices-ip.csv')


# iterate the devices in order
foreach ($d in $devs)
{
    function Get-reboot_device
    {
        start-sleep 5
        if($d.username-and$d.password)
        {
            Write-Host "rebooting $($d.Room_Name)..."
            Invoke-CrestronCommand -Device $d.Device -Command "reboot" -username $d.username -secure -password $d.password -Timeout 20
        }
        # reboot to complete
        Write-Host "rebooting $($d.Room_Name)..."
        Invoke-CrestronCommand -Device $d.Device -Command "reboot" -Timeout 20
    }
    # checks for device
    if($d.Device)
    {
        write-host "Beginning: $($d.device),$($d.Description),$($d.Room_Name)..."
        # checks if the device is a processor
        if($d.Description.StartsWith("RMC3")-Or$d.Description.StartsWith("DMPS")-or$d.Description.StartsWith("CP3"))
        {
            # checks if there is a config file to push
            if($d.config_file_name-and$d.config_file_path)
            {
                if($d.program_name)
                {
                    # makes folder if required
                    Invoke-CrestronCommand -Device $d.Device -Command "MAKEDIR nvram\\$($d.program_name)" -Timeout 20
                    # send config to that folder
                    Send-FTPFile -Device $d.Device -LocalFile "$($d.config_file_path)-$($d.Room_Number).json" -RemoteFile "\\NVRAM\\$($d.program_name)\\$($d.config_file_name)" # -Timeout 60
                    Write-Host "Sending Config $($d.config_file_name) to $($d.program_name)"
                } else {
                    # send config to root folder
                    Send-FTPFile -Device $d.Device -LocalFile "$($d.config_file_path)-$($d.Room_Number).json" -RemoteFile "\\NVRAM\\$($d.config_file_name)" # -Timeout 60
                    Write-Host "Sending Config $($d.config_file_name) to NVRAM"
                }
                start-sleep 5
            }
            # add 0 for processors
            $zero = " 0"
        # checks if nvx
        } elseif ($d.Description.StartsWith("DM-NVX")) {
            # $secure = "-Password admin -Secure -Username admin"
            if($d.IPID-and$d.processorIP-and$d.username-and$d.password)
            {
                # sets ipid for nvx
                Invoke-CrestronCommand -Device $d.Device -Command "addmaster $($d.IPID) $($d.processorIP)" -username $d.username -secure -password $d.password -Timeout 20
                Write-Host "setting ipid master:$($d.processorIP) IPID $($d.IPID)"
                if(-Not$d.IP)
                {
                    Get-reboot_device
                }
            } else {
                write-host "could not find ip/ssh credentials"
            }
            $zero = ""
        } elseif ($d.Description.StartsWith("DM-")) {
            # no 0 for dm endpoints
            $zero = ""
            # checks for ipid requirements and not a processor
            if($d.IPID-and$d.processorIP)
            {
                # sets ipid for dm devices
                Invoke-CrestronCommand -Device $d.Device -Command "addmaster $($d.IPID) $($d.processorIP)"  -Timeout 20
                Write-Host "setting ipid master:$($d.processorIP) IPID $($d.IPID)"
                if(-Not$d.IP)
                {
                    Get-reboot_device
                }
            }

        } else {
            write-host "description not found"
        }
        # sets all network settings for secure devices
        if ($d.IP-and$d.Subnet-and$d.Gateway-and$d.username-and$d.password)
        {
            # turn off dhcp
            write-Host "Updating IP $($d.Device) to $($d.Room_Name)..."
            Invoke-CrestronCommand -Device $d.Device -Command "dhcp off" -username $d.username -secure -password $d.password -Timeout 20
            write-host "dhcp off"
            # set ip
            Invoke-CrestronCommand -Device $d.Device -Command "ipa $($d.IP)" -username $d.username -secure -password $d.password -Timeout 20
            write-host "ipa $($d.IP)"
            # set subnet
            Invoke-CrestronCommand -Device $d.Device -Command "ipmask $($d.Subnet)" -username $d.username -secure -password $d.password -Timeout 20
            write-host "ipmask $($d.Subnet)"
            # set gateway
            Invoke-CrestronCommand -Device $d.Device -Command "defr $($d.Gateway)" -username $d.username -secure -password $d.password -Timeout 20
            write-host "defr $($d.Gateway)"
            # check for host
            if($d.Hostname)
            {
                Invoke-CrestronCommand -Device $d.Device -Command "hostname $($d.Hostname)" -username $d.username -secure -password $d.password -Timeout 20
                Write-Host "Hostname Set $($d.Hostname)"
            }
            Get-reboot_device

        }
        # not secure network config
        elseif($d.IP-and$d.Subnet-and$d.Gateway)
        {
            # turn off dhcp
            Write-Host "Updating IP $($d.Device) to $($d.Room_Name)..."
            Invoke-CrestronCommand -Device $d.Device -Command "dhcp$zero off"  -Timeout 20
            write-host "dhcp $zero off"
            # set ip
            Invoke-CrestronCommand -Device $d.Device -Command "ipa$zero $($d.IP)"   -Timeout 20
            write-host "ipa $zero $($d.IP)"
            # set subnet
            Invoke-CrestronCommand -Device $d.Device -Command "ipmask$zero $($d.Subnet)" -Timeout 20
            write-host "ipmask $zero $($d.Subnet)"
            # set gateway
            Invoke-CrestronCommand -Device $d.Device -Command "defr$zero $($d.Gateway)"  -Timeout 20
            write-host "defr $zero $($d.Gateway)"
            # check for host
            if($d.Hostname)
            {
                Invoke-CrestronCommand -Device $d.Device -Command "hostname $($d.Hostname)" -Timeout 20
                Write-Host "Hostname Set $($d.Hostname)"
            }
            Get-reboot_device
        }
    }
}

Write-Host 'Done.'

Read-Host -Prompt “Press Enter to exit”