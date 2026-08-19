<#
.SYNOPSIS
    Recursively finds and removes empty folders under a given path.
.PARAMETER Path
    Root folder to scan.
.PARAMETER WhatIf
    If set, only lists empty folders without deleting them.
.EXAMPLE
    .\Remove-EmptyFolders.ps1 -Path "C:\Projects" -WhatIf
.EXAMPLE
    .\Remove-EmptyFolders.ps1 -Path "C:\Projects"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [switch]$WhatIf
)

if (-not (Test-Path $Path)) {
    Write-Host "Path does not exist: $Path" -ForegroundColor Red
    exit 1
}

do {
    $emptyFolders = Get-ChildItem -Path $Path -Recurse -Directory |
        Where-Object { (Get-ChildItem $_.FullName -Force | Measure-Object).Count -eq 0 }

    foreach ($folder in $emptyFolders) {
        if ($WhatIf) {
            Write-Host "Would remove: $($folder.FullName)" -ForegroundColor Yellow
        } else {
            Remove-Item -Path $folder.FullName -Force
            Write-Host "Removed: $($folder.FullName)" -ForegroundColor Green
        }
    }
} while (-not $WhatIf -and $emptyFolders.Count -gt 0)

Write-Host "`nDone." -ForegroundColor Cyan