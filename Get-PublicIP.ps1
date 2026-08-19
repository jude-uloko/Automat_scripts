<#
.SYNOPSIS
    Retrieves your current public IP address and basic geolocation info.
.EXAMPLE
    .\Get-PublicIP.ps1
#>

try {
    $info = Invoke-RestMethod -Uri "https://ipinfo.io/json" -TimeoutSec 10

    Write-Host "===== Public IP Info =====" -ForegroundColor Cyan
    Write-Host "IP:        $($info.ip)"
    Write-Host "City:      $($info.city)"
    Write-Host "Region:    $($info.region)"
    Write-Host "Country:   $($info.country)"
    Write-Host "ISP/Org:   $($info.org)"
    Write-Host "Timezone:  $($info.timezone)"
} catch {
    Write-Host "Could not retrieve public IP info. Check your internet connection." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor DarkRed
}