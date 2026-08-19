<#
.SYNOPSIS
    Exports all attachments from a specified Outlook folder into one local folder.
.DESCRIPTION
    Requires Outlook desktop app to be installed and running/configured.
.PARAMETER OutlookFolder
    Name of the Outlook folder to scan (e.g. "Inbox"). Defaults to "Inbox".
.PARAMETER DestinationPath
    Local folder to save attachments to.
.PARAMETER DaysBack
    Only process emails from the last N days. Defaults to 30.
.EXAMPLE
    .\Export-OutlookAttachments.ps1 -DestinationPath "C:\Attachments" -DaysBack 7
#>

param(
    [string]$OutlookFolder = "Inbox",
    [Parameter(Mandatory=$true)]
    [string]$DestinationPath,
    [int]$DaysBack = 30
)

try {
    $outlook = New-Object -ComObject Outlook.Application
} catch {
    Write-Host "Could not connect to Outlook. Make sure it's installed." -ForegroundColor Red
    exit 1
}

$namespace = $outlook.GetNamespace("MAPI")
$folder = $namespace.GetDefaultFolder(6)  # 6 = olFolderInbox

if ($OutlookFolder -ne "Inbox") {
    $folder = $folder.Parent.Folders.Item($OutlookFolder)
}

if (-not (Test-Path $DestinationPath)) {
    New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

$cutoff = (Get-Date).AddDays(-$DaysBack)
$count = 0

foreach ($item in $folder.Items) {
    if ($item.ReceivedTime -lt $cutoff) { continue }
    if ($item.Attachments.Count -eq 0) { continue }

    foreach ($attachment in $item.Attachments) {
        $safeSubject = ($item.Subject -replace '[\\/:*?"<>|]', '_').Substring(0, [Math]::Min(30, $item.Subject.Length))
        $fileName = "$($item.ReceivedTime.ToString('yyyyMMdd'))_${safeSubject}_$($attachment.FileName)"
        $savePath = Join-Path $DestinationPath $fileName

        try {
            $attachment.SaveAsFile($savePath)
            Write-Host "Saved: $fileName" -ForegroundColor Green
            $count++
        } catch {
            Write-Host "Failed to save attachment from '$($item.Subject)': $_" -ForegroundColor Red
        }
    }
}

Write-Host "`nDone. $count attachments exported to $DestinationPath" -ForegroundColor Cyan