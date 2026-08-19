<#
.SYNOPSIS
    Exports a full registry backup, or a specific key, before making risky changes.
.PARAMETER KeyPath
    Specific registry key to export (e.g. "HKCU\Software\MyApp"). If omitted, backs up entire registry.
.PARAMETER DestinationPath
    Folder to save the .reg backup file in. Defaults to Desktop.
.EXAMPLE
    .\Backup-Registry.ps1
    .\Backup-Registry.ps1 -KeyPath "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
#>

param(
    [string]$KeyPath,
    [string]$DestinationPath = "$env:USERPROFILE\Desktop"
)

if (-not (Test-Path $DestinationPath)) {
    New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'

if ($KeyPath) {
    $safeName = $KeyPath -replace '[\\:]', '_'
    $outFile = Join-Path $DestinationPath "RegBackup_${safeName}_$timestamp.reg"
    Write-Host "Backing up key: $KeyPath" -ForegroundColor Cyan
    reg export "$KeyPath" "$outFile" /y
} else {
    $outFile = Join-Path $DestinationPath "FullRegistryBackup_$timestamp.reg"
    Write-Host "Backing up full registry (this can take a minute and produce a large file)..." -ForegroundColor Cyan
    reg export HKLM "$DestinationPath\HKLM_Backup_$timestamp.reg" /y
    reg export HKCU "$DestinationPath\HKCU_Backup_$timestamp.reg" /y
    $outFile = "$DestinationPath\HKLM_Backup_$timestamp.reg and HKCU_Backup_$timestamp.reg"
}

Write-Host "`nBackup saved: $outFile" -ForegroundColor Green
Write-Host "To restore: double-click the .reg file, or use 'reg import <file>'" -ForegroundColor DarkGray