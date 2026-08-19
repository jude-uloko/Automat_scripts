<#
.SYNOPSIS
    Copies your PowerShell profile, VS Code settings, and other config files into a backup folder (e.g. this repo).
.PARAMETER DestinationPath
    Folder to copy configs into. Defaults to a "dotfiles" subfolder in the current directory.
.EXAMPLE
    .\Backup-DotFiles.ps1 -DestinationPath "C:\Repos\PowerShell-Scripts\dotfiles"
#>

param(
    [string]$DestinationPath = (Join-Path (Get-Location).Path "dotfiles")
)

if (-not (Test-Path $DestinationPath)) {
    New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

$targets = @{
    "PowerShell_Profile.ps1" = $PROFILE
    "VSCode_settings.json"   = "$env:APPDATA\Code\User\settings.json"
    "VSCode_keybindings.json"= "$env:APPDATA\Code\User\keybindings.json"
    "GitConfig"              = "$env:USERPROFILE\.gitconfig"
    "WindowsTerminal_settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
}

foreach ($name in $targets.Keys) {
    $source = $targets[$name]
    if (Test-Path $source) {
        $dest = Join-Path $DestinationPath $name
        Copy-Item -Path $source -Destination $dest -Force
        Write-Host "Backed up: $name" -ForegroundColor Green
    } else {
        Write-Host "Not found (skipped): $name" -ForegroundColor Yellow
    }
}

Write-Host "`nDone. Configs backed up to $DestinationPath" -ForegroundColor Cyan
Write-Host "Tip: commit and push this folder to keep your setup portable." -ForegroundColor DarkGray