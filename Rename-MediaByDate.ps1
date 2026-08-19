<#
.SYNOPSIS
    Renames photos/videos using their file creation date (or EXIF date for JPEGs).
.PARAMETER Path
    Folder containing media files.
.PARAMETER Format
    Date/time format for the new filename. Defaults to "yyyy-MM-dd_HH-mm-ss".
.EXAMPLE
    .\Rename-MediaByDate.ps1 -Path "C:\Photos"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [string]$Format = "yyyy-MM-dd_HH-mm-ss"
)

Add-Type -AssemblyName System.Drawing

function Get-ExifDate($filePath) {
    try {
        $img = [System.Drawing.Image]::FromFile($filePath)
        $propItem = $img.GetPropertyItem(36867)  # DateTimeOriginal tag
        $dateStr = [System.Text.Encoding]::ASCII.GetString($propItem.Value).Trim([char]0)
        $img.Dispose()
        return [datetime]::ParseExact($dateStr, "yyyy:MM:dd HH:mm:ss", $null)
    } catch {
        return $null
    }
}

$extensions = @(".jpg", ".jpeg", ".png", ".mp4", ".mov", ".avi")
$files = Get-ChildItem -Path $Path -File | Where-Object { $extensions -contains $_.Extension.ToLower() }
$usedNames = @{}

foreach ($file in $files) {
    $date = $null
    if ($file.Extension.ToLower() -in @(".jpg", ".jpeg")) {
        $date = Get-ExifDate $file.FullName
    }
    if (-not $date) {
        $date = $file.CreationTime
    }

    $baseName = $date.ToString($Format)
    $newName = "$baseName$($file.Extension)"
    $counter = 1
    while ($usedNames.ContainsKey($newName)) {
        $newName = "${baseName}_$counter$($file.Extension)"
        $counter++
    }
    $usedNames[$newName] = $true

    $newPath = Join-Path $Path $newName
    Rename-Item -Path $file.FullName -NewName $newName
    Write-Host "Renamed: $($file.Name) -> $newName" -ForegroundColor Green
}

Write-Host "`nDone. $($files.Count) files renamed." -ForegroundColor Cyan