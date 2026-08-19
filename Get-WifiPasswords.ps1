<#
.SYNOPSIS
    Shows saved WiFi network names and their passwords on this PC.
.DESCRIPTION
    Uses netsh to read profiles this PC has already connected to and saved.
    Requires running as Administrator to reveal the key content.
.EXAMPLE
    .\Get-WifiPasswords.ps1
#>

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator to reveal saved passwords." -ForegroundColor Red
    exit 1
}

$profiles = (netsh wlan show profiles) | Select-String "All User Profile" | ForEach-Object {
    ($_ -split ":")[1].Trim()
}

$results = @()

foreach ($profile in $profiles) {
    $details = netsh wlan show profile name="$profile" key=clear
    $keyLine = $details | Select-String "Key Content"
    $password = if ($keyLine) { ($keyLine -split ":")[1].Trim() } else { "(none / open network)" }

    $results += [PSCustomObject]@{
        SSID     = $profile
        Password = $password
    }
}

$results | Format-Table -AutoSize
Write-Host "`nFound $($results.Count) saved networks." -ForegroundColor Cyan