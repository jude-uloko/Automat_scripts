<#
.SYNOPSIS
    Lists all USB devices currently connected and previously connected (device history).
.EXAMPLE
    .\Get-USBDeviceHistory.ps1
#>

Write-Host "===== Currently Connected USB Devices =====" -ForegroundColor Cyan
Get-PnpDevice -Class USB -Status OK | Select-Object FriendlyName, InstanceId | Format-Table -AutoSize

Write-Host "`n===== USB Storage Device History (Registry) =====" -ForegroundColor Cyan
$usbStorPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"

if (Test-Path $usbStorPath) {
    Get-ChildItem $usbStorPath | ForEach-Object {
        $deviceType = $_.PSChildName
        Get-ChildItem $_.PSPath | ForEach-Object {
            $props = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue
            if ($props.FriendlyName) {
                Write-Host "$($props.FriendlyName)" -ForegroundColor Green
                Write-Host "  Type: $deviceType"
                Write-Host "  Serial: $($_.PSChildName)"
            }
        }
    }
} else {
    Write-Host "No USB storage history found (or insufficient permissions)." -ForegroundColor Yellow
}