# $TestScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
# $ModuleRoot = Resolve-Path "$TestScriptRoot\.."
# $ModuleManifest = "$ModuleRoot\Recon\Recon.psd1"

# Remove-Module [R]econ
# Import-Module $ModuleManifest -Force -ErrorAction Stop

# # import PowerView.ps1 manually so we expose the helper functions for testing
# $PowerViewFile = "$ModuleRoot\Recon\PowerView.ps1"
# Import-Module $PowerViewFile -Force -ErrorAction Stop


# # Get the local IP address for later testing
# $IPregex = "(?<Address>((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))"
# $LocalIP = (gwmi Win32_NetworkAdapterConfiguration | ? { $_.IPAddress -match $IPregex}).ipaddress[0]


# Describe 'Get-Proxy' {
#     It 'Should Not Throw' {
#         {Get-Proxy} | Should Not Throw
#     }
#     It 'Should accept -ComputerName argument' {
#         {Get-Proxy -ComputerName $env:COMPUTERNAME} | Should Not Throw
#     }   
# }