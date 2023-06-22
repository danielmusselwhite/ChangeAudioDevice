#region If AudioDeviceCmdlets is not installed, either install it automatically (if in admin mode) or tell user to install it (if not)
# If the AudioDeviceCmdlets module is not installed...
if(!(Get-Module -ListAvailable -Name AudioDeviceCmdlets)) {
    #... If this is not admin mode, tell user this cannot run as cmdlet is missing and exit early
    if(-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "AudioDeviceCmdlets is not installed. Please run this script in admin mode to have it automatically installed or install it manually." -ForegroundColor Red
        exit
    }
    #... Else, this is admin mode prompt user to ask if they wish to install it
    else {
        Write-Host "AudioDeviceCmdlets is required by this Script. Would you like to install it now? (Y/N)"
        $install = Read-Host
        if($install -eq "Y") {
            Write-Host "Installing AudioDeviceCmdlets..." -ForegroundColor Yellow
            Install-Module -Name AudioDeviceCmdlets
            Write-Host "AudioDeviceCmdlets installed." -ForegroundColor Green
        }
        else {
            Write-Host "AudioDeviceCmdlets is not installed. Please install it manually." -ForegroundColor Red
            exit
        }
    }
}
#endregion

#region Checking command line arguments
# we are expecting 0 or 1 arguments, exit if more are provided
if($args.Length -gt 1) {
    Write-Host "Too many arguments provided.`n`tPlease provide 0 arguments if you wish to select audio device interactively `n`tOr, 1 argument if you wish to bypass the interactive selection and already know the index you wish to switch to." -ForegroundColor Red
    exit
}

# if 1 argument is provided, check it is an integer (positive or negative)
if($args.Length -eq 1) {
    if($args[0] -notmatch "^\d+$") { # regex excluding negative integers
        Write-Host "Argument provided is not a number. Please provide the numerical index of the audio device you wish to switch to." -ForegroundColor Red
        exit
    }
    else{
        $index = $args[0]
        Write-Host "Argument provided is a number. Will attempt to switch to audio device with index $index"
    }
}
#endregion

#region Interactively selecting audio device if not provided at command line
if($args.Length -eq 0) {
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
        Write-Host "Cancelling..."
        exit
    }
}
#endregion

#region Switching to selected audio device
# Check if $index is within the range of indexes of audio devices
if($index -gt (Get-AudioDevice -List | Where-Object { $_.Type -eq "Playback" }).Count -or $index -lt 1) {
    Write-Host "Index provided is out of range. Please provide the numerical index of the audio device you wish to switch to." -ForegroundColor Red
    exit
}

# Switch to the device with the index that the user selected
Set-AudioDevice -Index $index
$newName = (Get-AudioDevice -List | Where-Object { $_.Type -eq "Playback" -and $_.Index -eq $index}).Name
Write-Host "Switched to audio device with index $index and name '$newName'" -ForegroundColor Green
#endregion