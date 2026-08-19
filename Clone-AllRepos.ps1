<#
.SYNOPSIS
    Reads a list of git repo URLs from a text file and clones them all into a target folder.
.PARAMETER ListFile
    Path to a .txt file with one repo URL per line.
.PARAMETER DestinationPath
    Folder to clone repos into. Created if it doesn't exist.
.EXAMPLE
    .\Clone-AllRepos.ps1 -ListFile "C:\repos.txt" -DestinationPath "C:\Projects"

    Example repos.txt content:
    https://github.com/user/repo1.git
    https://github.com/user/repo2.git
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ListFile,

    [Parameter(Mandatory=$true)]
    [string]$DestinationPath
)

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed or not in PATH." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ListFile)) {
    Write-Host "List file not found: $ListFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $DestinationPath)) {
    New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

$repos = Get-Content $ListFile | Where-Object { $_.Trim() -ne "" }

Push-Location $DestinationPath
foreach ($repo in $repos) {
    Write-Host "`nCloning: $repo" -ForegroundColor Cyan
    git clone $repo.Trim()
}
Pop-Location

Write-Host "`nDone. $($repos.Count) repos processed." -ForegroundColor Green