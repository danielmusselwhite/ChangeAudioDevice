#region If AudioDeviceCmdlets is not installed, either install it automatically (if in admin mode) or tell user to install it (if not)
# If the AudioDeviceCmdlets module is not installed...
if(!(Get-Module -ListAvailable -Name AudioDeviceCmdlets)) {
    #... If this is not admin mode, tell user this cannot run as cmdlet is missing and exit early
    if(-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "AudioDeviceCmdlets is not installed. Please run this script in admin mode to have it automatically installed or install it manually."
        exit
    }
    #... Else, this is admin mode get user to confirm they want AudioDeviceCmdlets installed
    else {
        Write-Host "AudioDeviceCmdlets is required by this Script. Would you like to install it now? (Y/N)"
        $install = Read-Host
        if($install -eq "Y") {
            # Install AudioDeviceCmdlets
            Install-Module -Name AudioDeviceCmdlets
        }
        else {
            exit
        }
    }
}
#endregion

# Output list of all audio output devices with a corresponding index as a table
Write-Host "Please select an audio device to change to:"
Get-AudioDevice -List | Where-Object { $_.Type -eq "Playback" } | Format-Table -Property Name, Index -AutoSize


# Output the currently active audio output device along with its numerical index from above
Write-Host "`nCurrently active audio device is:"
$activeDevice = Get-AudioDevice -Playback | Where-Object { $_."Default" -eq "True"}
Write-Host "$($activeDevice.Name) ($($activeDevice.Index))"


# Ask user which device they wish to switch to or cancel
Write-Host "Please enter the index of the device you wish to switch to or enter 'cancel' to cancel:"
$index = Read-Host
if($index -eq "cancel") {
    exit
}

# Switch to the device with the index that the user selected
Set-AudioDevice -Index $index


