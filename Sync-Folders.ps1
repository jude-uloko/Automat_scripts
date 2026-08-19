<#
.SYNOPSIS
    Syncs (mirrors) one folder to another using Robocopy - great for simple manual backups.
.PARAMETER Source
    Source folder.
.PARAMETER Destination
    Destination folder to mirror the source into.
.PARAMETER Mirror
    If set, makes destination an exact mirror (deletes files in dest not in source).
    Without this, it's an additive sync only.
.EXAMPLE
    .\Sync-Folders.ps1 -Source "C:\Projects" -Destination "D:\Backup\Projects" -Mirror
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Source,

    [Parameter(Mandatory=$true)]
    [string]$Destination,

    [switch]$Mirror
)

if (-not (Test-Path $Source)) {
    Write-Host "Source path does not exist: $Source" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

$logFile = "$env:USERPROFILE\Desktop\SyncLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

$flags = if ($Mirror) { "/MIR" } else { "/E" }

Write-Host "Syncing '$Source' -> '$Destination'..." -ForegroundColor Cyan
if ($Mirror) {
    Write-Host "MIRROR mode: files removed from source will also be removed from destination." -ForegroundColor Yellow
}

robocopy $Source $Destination $flags /R:2 /W:5 /LOG:$logFile /TEE

$exitCode = $LASTEXITCODE
if ($exitCode -le 7) {
    Write-Host "`nSync completed successfully. Log: $logFile" -ForegroundColor Green
} else {
    Write-Host "`nSync completed with errors (exit code $exitCode). Check log: $logFile" -ForegroundColor Red
}