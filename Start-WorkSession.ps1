<#
.SYNOPSIS
    Launches your usual set of work apps and browser tabs in one command.
.DESCRIPTION
    Edit the $apps and $urls lists below to match your workflow.
.EXAMPLE
    .\Start-WorkSession.ps1
#>

# --- Customize these ---
$apps = @(
    "C:\Program Files\Microsoft VS Code\Code.exe",
    "C:\Program Files\Slack\slack.exe"
)

$urls = @(
    "https://mail.google.com",
    "https://github.com",
    "https://calendar.google.com"
)
# ------------------------

Write-Host "Starting work session..." -ForegroundColor Cyan

foreach ($app in $apps) {
    if (Test-Path $app) {
        Start-Process $app
        Write-Host "Launched: $app" -ForegroundColor Green
    } else {
        Write-Host "App not found (check path): $app" -ForegroundColor Yellow
    }
}

if ($urls.Count -gt 0) {
    Start-Process $urls[0]
    Start-Sleep -Seconds 1
    for ($i = 1; $i -lt $urls.Count; $i++) {
        Start-Process $urls[$i]
    }
    Write-Host "Opened $($urls.Count) browser tabs." -ForegroundColor Green
}

Write-Host "`nWork session ready." -ForegroundColor Cyan