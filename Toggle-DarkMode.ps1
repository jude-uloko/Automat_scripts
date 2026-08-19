<#
.SYNOPSIS
    Toggles Windows between light and dark theme.
.EXAMPLE
    .\Toggle-DarkMode.ps1
#>

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$appsKey = "AppsUseLightTheme"
$systemKey = "SystemUsesLightTheme"

$current = Get-ItemProperty -Path $regPath -Name $appsKey -ErrorAction SilentlyContinue

if ($current.$appsKey -eq 1) {
    # Currently light -> switch to dark
    Set-ItemProperty -Path $regPath -Name $appsKey -Value 0
    Set-ItemProperty -Path $regPath -Name $systemKey -Value 0
    Write-Host "Switched to Dark Mode." -ForegroundColor DarkGray
} else {
    # Currently dark -> switch to light
    Set-ItemProperty -Path $regPath -Name $appsKey -Value 1
    Set-ItemProperty -Path $regPath -Name $systemKey -Value 1
    Write-Host "Switched to Light Mode." -ForegroundColor Yellow
}

# Restart Explorer so the change applies immediately
Stop-Process -Name explorer -Force
Start-Process explorer