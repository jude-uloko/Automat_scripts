<#
.SYNOPSIS
    Generates a quick system info report: CPU, RAM, Disk, Network, OS.
.EXAMPLE
    .\Get-SystemInfo.ps1
#>

$report = @()
$report += "===== SYSTEM INFO REPORT ====="
$report += "Generated: $(Get-Date)"
$report += ""

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor

$report += "--- OS ---"
$report += "OS: $($os.Caption) $($os.OSArchitecture)"
$report += "Version: $($os.Version)"
$report += "Last Boot: $($os.LastBootUpTime)"
$report += ""

$report += "--- CPU ---"
$report += "Processor: $($cpu.Name)"
$report += "Cores: $($cpu.NumberOfCores) | Logical Processors: $($cpu.NumberOfLogicalProcessors)"
$report += "Current Load: $($cpu.LoadPercentage)%"
$report += ""

$report += "--- Memory ---"
$totalRAM = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$report += "Total RAM: $totalRAM GB"
$report += "Free RAM: $freeRAM GB"
$report += ""

$report += "--- Disks ---"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $freeGB = [math]::Round($_.FreeSpace / 1GB, 2)
    $totalGB = [math]::Round($_.Size / 1GB, 2)
    $report += "$($_.DeviceID) $freeGB GB free of $totalGB GB"
}
$report += ""

$report += "--- Network ---"
Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.*" -and $_.InterfaceAlias -notlike "*Loopback*" } |
    ForEach-Object { $report += "$($_.InterfaceAlias): $($_.IPAddress)" }

$report | ForEach-Object { Write-Host $_ }

$outFile = "$env:USERPROFILE\Desktop\SystemInfo_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$report | Out-File -FilePath $outFile -Encoding UTF8
Write-Host "`nReport saved to $outFile" -ForegroundColor Green