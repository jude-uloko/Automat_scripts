<#
.SYNOPSIS
    Lists programs configured to run at Windows startup, from registry and startup folders.
.EXAMPLE
    .\List-StartupPrograms.ps1
#>

Write-Host "===== Startup Programs (Registry) =====" -ForegroundColor Cyan

$regPaths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($path in $regPaths) {
    if (Test-Path $path) {
        $items = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
        $items.PSObject.Properties |
            Where-Object { $_.Name -notlike "PS*" } |
            ForEach-Object { Write-Host "$($_.Name): $($_.Value)" }
    }
}

Write-Host "`n===== Startup Folder Items =====" -ForegroundColor Cyan

$startupFolders = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
)

foreach ($folder in $startupFolders) {
    if (Test-Path $folder) {
        Get-ChildItem -Path $folder -File | ForEach-Object { Write-Host $_.Name }
    }
}

Write-Host "`nTip: Use Task Manager > Startup tab for impact ratings, or disable items here by removing the registry value / shortcut." -ForegroundColor Yellow