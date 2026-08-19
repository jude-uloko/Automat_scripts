<#
.SYNOPSIS
    Watches a folder and automatically moves/renames files as they appear.
.DESCRIPTION
    Useful for auto-processing a "drop folder" - e.g. auto-sorting scans or exports.
.PARAMETER Path
    Folder to watch.
.PARAMETER DestinationPath
    Folder to move new files into.
.PARAMETER Filter
    File filter, e.g. "*.pdf". Defaults to "*.*".
.EXAMPLE
    .\Watch-Folder.ps1 -Path "C:\Scans" -DestinationPath "C:\Scans\Processed" -Filter "*.pdf"
    (Press Ctrl+C to stop)
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [Parameter(Mandatory=$true)]
    [string]$DestinationPath,

    [string]$Filter = "*.*"
)

if (-not (Test-Path $Path)) {
    Write-Host "Watch path does not exist: $Path" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $DestinationPath)) {
    New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $Path
$watcher.Filter = $Filter
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$action = {
    Start-Sleep -Milliseconds 500  # let file finish writing
    $filePath = $Event.SourceEventArgs.FullPath
    $fileName = $Event.SourceEventArgs.Name
    $dest = Join-Path $DestinationPath $fileName

    try {
        Move-Item -Path $filePath -Destination $dest -Force
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Moved: $fileName" -ForegroundColor Green
    } catch {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Failed to move $fileName : $_" -ForegroundColor Red
    }
}

Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action | Out-Null

Write-Host "Watching '$Path' for new files matching '$Filter'..." -ForegroundColor Cyan
Write-Host "New files will move to '$DestinationPath'. Press Ctrl+C to stop." -ForegroundColor Cyan

while ($true) { Start-Sleep -Seconds 1 }