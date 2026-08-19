<#
.SYNOPSIS
    Bulk renames files in a folder: add prefix/suffix or sequential numbering.
.PARAMETER Path
    Folder containing files to rename.
.PARAMETER Prefix
    Text to prepend to each filename.
.PARAMETER Suffix
    Text to append before the extension.
.PARAMETER Sequential
    If set, renames files as Name_001, Name_002, etc.
.PARAMETER BaseName
    Base name to use when -Sequential is set.
.EXAMPLE
    .\Rename-BatchFiles.ps1 -Path "C:\Photos" -Sequential -BaseName "Vacation"
.EXAMPLE
    .\Rename-BatchFiles.ps1 -Path "C:\Docs" -Prefix "2026_"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [string]$Prefix = "",
    [string]$Suffix = "",
    [switch]$Sequential,
    [string]$BaseName = "File"
)

if (-not (Test-Path $Path)) {
    Write-Host "Path does not exist: $Path" -ForegroundColor Red
    exit 1
}

$files = Get-ChildItem -Path $Path -File
$count = 1

foreach ($file in $files) {
    $ext = $file.Extension
    if ($Sequential) {
        $newName = "{0}_{1:D3}{2}" -f $BaseName, $count, $ext
    } else {
        $newName = "$Prefix$($file.BaseName)$Suffix$ext"
    }

    $newPath = Join-Path $Path $newName
    if (Test-Path $newPath) {
        Write-Host "Skipped (name exists): $newName" -ForegroundColor Yellow
        continue
    }

    Rename-Item -Path $file.FullName -NewName $newName
    Write-Host "Renamed: $($file.Name) -> $newName" -ForegroundColor Green
    $count++
}

Write-Host "`nDone. $($count - 1) files renamed." -ForegroundColor Cyan