<#
.SYNOPSIS
    Sorts files in the Downloads folder into subfolders by type.
.PARAMETER Path
    Folder to sort. Defaults to the user's Downloads folder.
.EXAMPLE
    .\Sort-DownloadsFolder.ps1
#>

param(
    [string]$Path = "$env:USERPROFILE\Downloads"
)

$categories = @{
    "Images"      = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".webp")
    "Documents"   = @(".pdf", ".doc", ".docx", ".txt", ".xlsx", ".pptx", ".csv")
    "Installers"  = @(".exe", ".msi")
    "Archives"    = @(".zip", ".rar", ".7z", ".tar", ".gz")
    "Videos"      = @(".mp4", ".mov", ".avi", ".mkv")
    "Audio"       = @(".mp3", ".wav", ".flac")
}

if (-not (Test-Path $Path)) {
    Write-Host "Path does not exist: $Path" -ForegroundColor Red
    exit 1
}

$files = Get-ChildItem -Path $Path -File
$movedCount = 0

foreach ($file in $files) {
    $ext = $file.Extension.ToLower()
    $targetFolder = $null

    foreach ($category in $categories.Keys) {
        if ($categories[$category] -contains $ext) {
            $targetFolder = $category
            break
        }
    }

    if (-not $targetFolder) { $targetFolder = "Other" }

    $destDir = Join-Path $Path $targetFolder
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
    }

    $destPath = Join-Path $destDir $file.Name
    if (-not (Test-Path $destPath)) {
        Move-Item -Path $file.FullName -Destination $destPath
        Write-Host "Moved: $($file.Name) -> $targetFolder\" -ForegroundColor Green
        $movedCount++
    }
}

Write-Host "`nDone. $movedCount files sorted." -ForegroundColor Cyan