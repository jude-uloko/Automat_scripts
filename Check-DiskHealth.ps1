<#
.SYNOPSIS
    Runs SMART status checks on all physical drives and flags any that are failing.
.EXAMPLE
    .\Check-DiskHealth.ps1
#>

Write-Host "===== Disk Health Check =====" -ForegroundColor Cyan

$disks = Get-PhysicalDisk

foreach ($disk in $disks) {
    $status = $disk.HealthStatus
    $color = switch ($status) {
        "Healthy" { "Green" }
        "Warning" { "Yellow" }
        default   { "Red" }
    }

    Write-Host "`nDisk: $($disk.FriendlyName)"
    Write-Host "  Media Type:    $($disk.MediaType)"
    Write-Host "  Size:          $([math]::Round($disk.Size / 1GB, 1)) GB"
    Write-Host "  Health Status: $status" -ForegroundColor $color
    Write-Host "  Operational:   $($disk.OperationalStatus)"
}

# Also pull reliability counters if available (may require admin)
Write-Host "`n===== Reliability Counters (if available) =====" -ForegroundColor Cyan
try {
    Get-StorageReliabilityCounter -PhysicalDisk $disks -ErrorAction Stop |
        Select-Object DeviceId, Temperature, Wear, ReadErrorsTotal, WriteErrorsTotal |
        Format-Table -AutoSize
} catch {
    Write-Host "Reliability counters unavailable (try running as Administrator)." -ForegroundColor Yellow
}