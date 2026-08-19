<#
.SYNOPSIS
    Installs a standard developer toolkit using winget.
.DESCRIPTION
    Edit the $tools list below to match your preferred setup.
.EXAMPLE
    .\Install-DevTools.ps1
#>

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Install App Installer from the Microsoft Store first." -ForegroundColor Red
    exit 1
}

$tools = @(
    "Git.Git",
    "Microsoft.VisualStudioCode",
    "OpenJS.NodeJS.LTS",
    "Python.Python.3.12",
    "Microsoft.PowerShell",
    "Docker.DockerDesktop",
    "Postman.Postman",
    "7zip.7zip"
)

foreach ($tool in $tools) {
    Write-Host "`nInstalling $tool ..." -ForegroundColor Cyan
    winget install --id $tool -e --accept-source-agreements --accept-package-agreements
}

Write-Host "`nAll installations attempted. Check output above for any failures." -ForegroundColor Green