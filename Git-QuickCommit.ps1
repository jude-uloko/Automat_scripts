<#
.SYNOPSIS
    Adds, commits, and pushes changes in the current git repo in one command.
.PARAMETER Message
    Commit message. Defaults to a timestamped message if not given.
.PARAMETER Branch
    Branch to push to. Defaults to current branch.
.EXAMPLE
    .\Git-QuickCommit.ps1 -Message "Fix login bug"
#>

param(
    [string]$Message = "Quick update - $(Get-Date -Format 'yyyy-MM-dd HH:mm')",
    [string]$Branch
)

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed or not in PATH." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path ".git")) {
    Write-Host "Current folder is not a git repository." -ForegroundColor Red
    exit 1
}

if (-not $Branch) {
    $Branch = git rev-parse --abbrev-ref HEAD
}

Write-Host "Staging changes..." -ForegroundColor Cyan
git add -A

$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes to commit." -ForegroundColor Yellow
    exit 0
}

Write-Host "Committing: $Message" -ForegroundColor Cyan
git commit -m "$Message"

Write-Host "Pushing to origin/$Branch..." -ForegroundColor Cyan
git push origin $Branch

Write-Host "`nDone." -ForegroundColor Green