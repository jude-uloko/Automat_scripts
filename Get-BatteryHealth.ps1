<#
.SYNOPSIS
    Generates a battery report and shows design vs. full-charge capacity (wear level).
.EXAMPLE
    .\Get-BatteryHealth.ps1
#>

$reportPath = "$env:USERPROFILE\Desktop\battery_report.html"

Write-Host "Generating battery report..." -ForegroundColor Cyan
powercfg /batteryreport /output $reportPath | Out-Null

if (Test-Path $reportPath) {
    Write-Host "Battery report saved to: $reportPath" -ForegroundColor Green

    # Try to pull quick capacity numbers via WMI as well
    try {
        $battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue
        if ($battery) {
            Write-Host "`nEstimated Charge Remaining: $($battery.EstimatedChargeRemaining)%"
            Write-Host "Status: $($battery.Status)"
        }
    } catch {}

    Write-Host "`nOpening full report in default browser..." -ForegroundColor Cyan
    Start-Process $reportPath
} else {
    Write-Host "Could not generate battery report. This device may not have a battery." -ForegroundColor Red
}