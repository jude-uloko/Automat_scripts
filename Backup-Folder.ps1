<#
.SYNOPSIS
    Zips a folder into a date-stamped backup archive.
.PARAMETER SourcePath
    Folder to back up.
.PARAMETER DestinationPath
    Where the backup zip should be saved.
.EXAMPLE
    .\Backup-Folder.ps1 -SourcePath "C:\Projects\MyApp" -DestinationPath "D:\Backups"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,

    [Parameter(Mandatory=$true)]
    [string]$DestinationPath
)

if (-not (Test-Path $SourcePath)) {
    Write-Host "Source path does not exist: $SourcePath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $DestinationPath)) {
    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
}

$folderName = Split-Path $SourcePath -Leaf
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$zipName = "${folderName}_Backup_$timestamp.zip"
$zipPath = Join-Path $DestinationPath $zipName

Write-Host "Backing up '$SourcePath' to '$zipPath'..." -ForegroundColor Cyan

try {
    Compress-Archive -Path "$SourcePath\*" -DestinationPath $zipPath -CompressionLevel Optimal
    $sizeMB = [math]::Round((Get-Item $zipPath).Length / 1MB, 2)
    Write-Host "Backup complete: $zipPath ($sizeMB MB)" -ForegroundColor Green
} catch {
    Write-Host "Backup failed: $_" -ForegroundColor Red
}