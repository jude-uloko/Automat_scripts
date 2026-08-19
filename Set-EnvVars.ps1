<#
.SYNOPSIS
    Quickly sets or reads environment variables from a simple config file.
.DESCRIPTION
    Config file format (one per line): NAME=VALUE
    Lines starting with # are treated as comments.
.PARAMETER ConfigFile
    Path to the .env-style config file.
.PARAMETER Scope
    "User", "Machine", or "Process". Defaults to "Process" (current session only).
.EXAMPLE
    .\Set-EnvVars.ps1 -ConfigFile "C:\dev\myproject.env" -Scope User
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ConfigFile,

    [ValidateSet("User", "Machine", "Process")]
    [string]$Scope = "Process"
)

if (-not (Test-Path $ConfigFile)) {
    Write-Host "Config file not found: $ConfigFile" -ForegroundColor Red
    exit 1
}

$lines = Get-Content $ConfigFile | Where-Object { $_.Trim() -ne "" -and -not $_.StartsWith("#") }

foreach ($line in $lines) {
    if ($line -match "^\s*([^=]+)=(.*)$") {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()

        [Environment]::SetEnvironmentVariable($name, $value, $Scope)
        Write-Host "Set $name (scope: $Scope)" -ForegroundColor Green
    } else {
        Write-Host "Skipped invalid line: $line" -ForegroundColor Yellow
    }
}

Write-Host "`nDone. $($lines.Count) variables processed." -ForegroundColor Cyan
if ($Scope -ne "Process") {
    Write-Host "Note: You may need to restart apps/terminal for changes to take effect." -ForegroundColor Yellow
}