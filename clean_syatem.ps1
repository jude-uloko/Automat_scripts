<#
.SYNOPSIS
    Cleans temp files, recycle bin, and browser caches. Reports space freed.
.EXAMPLE
    .\Clean-System.ps1
#>

$ErrorActionPreference = 'SilentlyContinue'
$logFile = "$env:USERPROFILE\Desktop\CleanSystem_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$totalFreed = 0

function Get-FolderSize($path) {
    if (Test-Path $path) {
        return (Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum).Sum
    }
    return 0
}

function Write-Log($message) {
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "$timestamp - $message" | Tee-Object -FilePath $logFile -Append
}

Write-Log "=== System Cleanup Started ==="

# Windows Temp
$paths = @(
    "$env:TEMP",
    "$env:WINDIR\Temp",
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        $sizeBefore = Get-FolderSize $path
        Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue |
            Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        $sizeAfter = Get-FolderSize $path
        $freed = [math]::Round(($sizeBefore - $sizeAfter) / 1MB, 2)
        $totalFreed += $freed
        Write-Log "Cleaned: $path ($freed MB freed)"
    }
}

# Recycle Bin
try {
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Log "Recycle Bin emptied."
} catch {
    Write-Log "Could not empty Recycle Bin: $_"
}

Write-Log "=== Cleanup Complete: Approx $totalFreed MB freed ==="
Write-Host "`nDone. Log saved to $logFile" -ForegroundColor Green