<#
.SYNOPSIS
    Finds all .zip archives in a folder and extracts each into its own subfolder.
.PARAMETER Path
    Folder to scan for archives.
.PARAMETER DeleteAfterExtract
    If set, deletes the archive after successful extraction.
.EXAMPLE
    .\Extract-Archives.ps1 -Path "C:\Downloads"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [switch]$DeleteAfterExtract
)

if (-not (Test-Path $Path)) {
    Write-Host "Path does not exist: $Path" -ForegroundColor Red
    exit 1
}

$archives = Get-ChildItem -Path $Path -Filter "*.zip" -File

if ($archives.Count -eq 0) {
    Write-Host "No .zip files found in $Path" -ForegroundColor Yellow
    exit 0
}

foreach ($archive in $archives) {
    $destFolder = Join-Path $Path $archive.BaseName
    try {
        Write-Host "Extracting: $($archive.Name) -> $destFolder" -ForegroundColor Cyan
        Expand-Archive -Path $archive.FullName -DestinationPath $destFolder -Force

        if ($DeleteAfterExtract) {
            Remove-Item $archive.FullName -Force
            Write-Host "Deleted archive: $($archive.Name)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Failed to extract $($archive.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`nDone. $($archives.Count) archives processed." -ForegroundColor Green
Write-Host "Note: For .rar/.7z files, install 7-Zip and use its CLI (7z.exe) instead." -ForegroundColor DarkGray