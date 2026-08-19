<#
.SYNOPSIS
    Logs which processes are using the most CPU/RAM over time.
.PARAMETER IntervalSeconds
    Seconds between samples. Defaults to 10.
.PARAMETER TopN
    Number of top processes to log each sample. Defaults to 5.
.EXAMPLE
    .\Watch-ProcessCPU.ps1 -IntervalSeconds 15 -TopN 10
    (Press Ctrl+C to stop)
#>

param(
    [int]$IntervalSeconds = 10,
    [int]$TopN = 5
)

$logFile = "$env:USERPROFILE\Desktop\ProcessWatch_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
"Timestamp,ProcessName,CPU,MemoryMB" | Out-File -FilePath $logFile -Encoding UTF8

Write-Host "Monitoring top $TopN processes every $IntervalSeconds sec. Logging to $logFile. Press Ctrl+C to stop." -ForegroundColor Cyan

while ($true) {
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $topProcs = Get-Process | Sort-Object CPU -Descending | Select-Object -First $TopN

    Write-Host "`n--- $timestamp ---" -ForegroundColor Yellow
    foreach ($p in $topProcs) {
        $memMB = [math]::Round($p.WorkingSet64 / 1MB, 1)
        $cpu = if ($p.CPU) { [math]::Round($p.CPU, 1) } else { 0 }
        Write-Host "$($p.ProcessName): CPU=$cpu | RAM=$memMB MB"
        "$timestamp,$($p.ProcessName),$cpu,$memMB" | Out-File -FilePath $logFile -Append
    }

    Start-Sleep -Seconds $IntervalSeconds
}