<#
.SYNOPSIS
    Shows a popup reminder after a delay, or at a scheduled time.
.PARAMETER Message
    The reminder text to display.
.PARAMETER InMinutes
    Delay in minutes before showing the reminder.
.PARAMETER At
    Specific time to show the reminder (e.g. "14:30"). Overrides -InMinutes if set.
.EXAMPLE
    .\Remind-Me.ps1 -Message "Stand-up meeting" -InMinutes 15
    .\Remind-Me.ps1 -Message "Take a break" -At "15:00"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Message,

    [int]$InMinutes,
    [string]$At
)

Add-Type -AssemblyName System.Windows.Forms

if ($At) {
    $target = [datetime]::ParseExact($At, "HH:mm", $null)
    if ($target -lt (Get-Date)) { $target = $target.AddDays(1) }
    $waitSeconds = [int]($target - (Get-Date)).TotalSeconds
} elseif ($InMinutes) {
    $waitSeconds = $InMinutes * 60
} else {
    Write-Host "Specify either -InMinutes or -At" -ForegroundColor Red
    exit 1
}

Write-Host "Reminder set for $([math]::Round($waitSeconds/60,1)) minutes from now. Waiting... (Ctrl+C to cancel)" -ForegroundColor Cyan
Start-Sleep -Seconds $waitSeconds

[System.Windows.Forms.MessageBox]::Show($Message, "Reminder", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null