# ChangeAudioDevice - PowerShell Module

## Description
- This simple module allows you to change the default audio device on your computer.
- Created this as it was tedious to manually change the default audio device in Windows 10.


## Installation
- Download the module
- (Optional) place it in your PowerShell Modules folder in the path so it is available globally/ you don't need to copy path to script to call it each time.

## Usage

### Interactive
- To change the default audio device, use the following command "ChangeAudioDevice.ps1" in PowerShell or simply double click the file.
- You will then be given a list of your output audio devices, when prompted input the index of the one you wish to switch to.

### Command Line Arguments
- To change the default audio device, if you already know the index of the device you wish to switch to, use the following command "ChangeAudioDevice.ps1 -Index {number}" in PowerShell where {number} is the index of the audio device you wish to switch to.
  - Example: 'ChangeAudioDevice.ps1 -Index 1'