<#
.SYNOPSIS
    Pings key hosts repeatedly and logs downtime with timestamps.
.PARAMETER IntervalSeconds
    Seconds between checks. Defaults to 5.
.PARAMETER Hosts
    Hosts to test. Defaults to Cloudflare and Google DNS.
.EXAMPLE
    .\Test-InternetConnection.ps1 -IntervalSeconds 10
    (Press Ctrl+C to stop)
#>

param(
    [int]$IntervalSeconds = 5,
    [string[]]$Hosts = @("1.1.1.1", "8.8.8.8")
)

$logFile = "$env:USERPROFILE\Desktop\ConnectionLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
Write-Host "Monitoring internet connection. Logging to $logFile. Press Ctrl+C to stop." -ForegroundColor Cyan

while ($true) {
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $up = $false

    foreach ($h in $Hosts) {
        if (Test-Connection -ComputerName $h -Count 1 -Quiet -ErrorAction SilentlyContinue) {
            $up = $true
            break
        }
    }

    if ($up) {
        Write-Host "$timestamp - Connection UP" -ForegroundColor Green
    } else {
        $line = "$timestamp - Connection DOWN"
        Write-Host $line -ForegroundColor Red
        $line | Out-File -FilePath $logFile -Append
    }

    Start-Sleep -Seconds $IntervalSeconds
}