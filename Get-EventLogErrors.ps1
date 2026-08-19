<#
.SYNOPSIS
    Pulls recent critical/error events from Windows Event Viewer into a readable report.
.PARAMETER Hours
    How far back to look, in hours. Defaults to 24.
.PARAMETER LogName
    Event log to query. Defaults to "System". Try "Application" too.
.EXAMPLE
    .\Get-EventLogErrors.ps1 -Hours 48 -LogName Application
#>

param(
    [int]$Hours = 24,
    [string]$LogName = "System"
)

$startTime = (Get-Date).AddHours(-$Hours)

Write-Host "Fetching Error/Critical events from '$LogName' log since $startTime..." -ForegroundColor Cyan

try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName   = $LogName
        Level     = 1, 2   # 1 = Critical, 2 = Error
        StartTime = $startTime
    } -ErrorAction Stop
} catch {
    Write-Host "No matching events found or log unavailable: $_" -ForegroundColor Yellow
    exit 0
}

$results = $events | Select-Object TimeCreated, Id, ProviderName, LevelDisplayName,
    @{Name="Message";Expression={$_.Message -replace "`r`n"," " }}

$results | Format-Table -AutoSize -Wrap

$outFile = "$env:USERPROFILE\Desktop\EventErrors_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$results | Export-Csv -Path $outFile -NoTypeInformation
Write-Host "`nFound $($events.Count) events. Report saved to $outFile" -ForegroundColor Green