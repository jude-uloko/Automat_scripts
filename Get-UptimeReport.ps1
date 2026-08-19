<#
.SYNOPSIS
    Reports current uptime and recent shutdown/restart history from the Event Log.
.EXAMPLE
    .\Get-UptimeReport.ps1
#>

$os = Get-CimInstance Win32_OperatingSystem
$lastBoot = $os.LastBootUpTime
$uptime = (Get-Date) - $lastBoot

Write-Host "===== Current Uptime =====" -ForegroundColor Cyan
Write-Host "Last Boot: $lastBoot"
Write-Host "Uptime: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"

Write-Host "`n===== Recent Shutdown/Restart Events =====" -ForegroundColor Cyan

try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        Id = 41, 1074, 6005, 6006, 6008
        StartTime = (Get-Date).AddDays(-14)
    } -ErrorAction Stop

    $events | Select-Object TimeCreated, Id, @{Name="Event";Expression={
        switch ($_.Id) {
            41   { "Unexpected shutdown (power loss/crash)" }
            1074 { "Planned shutdown/restart" }
            6005 { "System startup" }
            6006 { "Clean shutdown" }
            6008 { "Unexpected shutdown" }
            default { "Other" }
        }
    }} | Format-Table -AutoSize
} catch {
    Write-Host "No boot/shutdown events found in the last 14 days." -ForegroundColor Yellow
}