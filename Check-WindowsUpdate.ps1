<#
.SYNOPSIS
    Checks for available Windows updates without installing them.
.DESCRIPTION
    Uses the PSWindowsUpdate module if available, otherwise falls back to
    a basic COM-based check.
.EXAMPLE
    .\Check-WindowsUpdates.ps1
#>

if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
    Import-Module PSWindowsUpdate
    Write-Host "Checking for updates via PSWindowsUpdate..." -ForegroundColor Cyan
    Get-WindowsUpdate
} else {
    Write-Host "PSWindowsUpdate module not found. Falling back to basic check..." -ForegroundColor Yellow
    Write-Host "(Tip: Install-Module PSWindowsUpdate -Force for a much better experience)" -ForegroundColor DarkGray

    try {
        $updateSession = New-Object -ComObject Microsoft.Update.Session
        $updateSearcher = $updateSession.CreateUpdateSearcher()
        Write-Host "Searching for updates (may take a minute)..." -ForegroundColor Cyan
        $result = $updateSearcher.Search("IsInstalled=0 and Type='Software'")

        if ($result.Updates.Count -eq 0) {
            Write-Host "No pending updates found." -ForegroundColor Green
        } else {
            Write-Host "`nFound $($result.Updates.Count) available update(s):" -ForegroundColor Cyan
            foreach ($update in $result.Updates) {
                Write-Host " - $($update.Title)"
            }
        }
    } catch {
        Write-Host "Update check failed: $_" -ForegroundColor Red
    }
}