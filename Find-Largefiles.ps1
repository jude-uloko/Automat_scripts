<#
.SYNOPSIS
    Scans a drive/folder and lists the largest files.
.PARAMETER Path
    Root folder to scan. Defaults to C:\
.PARAMETER Top
    Number of largest files to show. Defaults to 20.
.EXAMPLE
    .\Find-LargeFiles.ps1 -Path "D:\" -Top 30
#>

param(
    [string]$Path = "C:\",
    [int]$Top = 20
)

Write-Host "Scanning $Path for large files... (this may take a while)" -ForegroundColor Cyan

$files = Get-ChildItem -Path $Path -Recurse -File -Force -ErrorAction SilentlyContinue |
    Sort-Object Length -Descending |
    Select-Object -First $Top

$results = $files | Select-Object `
    @{Name="SizeMB";Expression={[math]::Round($_.Length / 1MB, 2)}},
    FullName

$results | Format-Table -AutoSize

$outFile = "$env:USERPROFILE\Desktop\LargeFiles_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$results | Export-Csv -Path $outFile -NoTypeInformation
Write-Host "`nResults saved to $outFile" -ForegroundColor Green