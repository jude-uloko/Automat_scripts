<#
.SYNOPSIS
    Finds duplicate files in a folder based on content hash (not just name).
.PARAMETER Path
    Folder to scan recursively.
.PARAMETER DeleteDuplicates
    If set, deletes all but the first copy of each duplicate set. Use with caution.
.EXAMPLE
    .\Find-DuplicateFiles.ps1 -Path "C:\Photos"
    .\Find-DuplicateFiles.ps1 -Path "C:\Photos" -DeleteDuplicates
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [switch]$DeleteDuplicates
)

if (-not (Test-Path $Path)) {
    Write-Host "Path does not exist: $Path" -ForegroundColor Red
    exit 1
}

Write-Host "Scanning for duplicates in $Path... (this may take a while for large folders)" -ForegroundColor Cyan

$files = Get-ChildItem -Path $Path -Recurse -File
$hashTable = @{}
$duplicateGroups = @()

$i = 0
foreach ($file in $files) {
    $i++
    Write-Progress -Activity "Hashing files" -Status $file.Name -PercentComplete (($i / $files.Count) * 100)

    $hash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash
    if ($hashTable.ContainsKey($hash)) {
        $hashTable[$hash] += $file.FullName
    } else {
        $hashTable[$hash] = @($file.FullName)
    }
}

$totalWasted = 0
foreach ($hash in $hashTable.Keys) {
    if ($hashTable[$hash].Count -gt 1) {
        $group = $hashTable[$hash]
        $duplicateGroups += ,$group
        $fileSize = (Get-Item $group[0]).Length
        $totalWasted += $fileSize * ($group.Count - 1)

        Write-Host "`nDuplicate set ($($group.Count) copies):" -ForegroundColor Yellow
        $group | ForEach-Object { Write-Host "  $_" }

        if ($DeleteDuplicates) {
            for ($j = 1; $j -lt $group.Count; $j++) {
                Remove-Item -Path $group[$j] -Force
                Write-Host "  Deleted: $($group[$j])" -ForegroundColor Red
            }
        }
    }
}

$wastedMB = [math]::Round($totalWasted / 1MB, 2)
Write-Host "`n$($duplicateGroups.Count) duplicate sets found. $wastedMB MB wasted space." -ForegroundColor Cyan