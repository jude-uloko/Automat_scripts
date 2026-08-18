<#
.SYNOPSIS
    Scaffolds a new project folder with standard structure, README, and git init.
.PARAMETER Name
    Name of the project.
.PARAMETER Path
    Parent directory to create the project in. Defaults to current directory.
.EXAMPLE
    .\New-ProjectFolder.ps1 -Name "MyApp" -Path "C:\Projects"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [string]$Path = (Get-Location).Path
)

$projectPath = Join-Path $Path $Name

if (Test-Path $projectPath) {
    Write-Host "Folder already exists: $projectPath" -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Path $projectPath | Out-Null
New-Item -ItemType Directory -Path "$projectPath\src" | Out-Null
New-Item -ItemType Directory -Path "$projectPath\docs" | Out-Null
New-Item -ItemType Directory -Path "$projectPath\tests" | Out-Null

@"
# $Name

## Description
TODO: Add project description.

## Setup
TODO: Add setup instructions.
"@ | Out-File -FilePath "$projectPath\README.md" -Encoding UTF8

@"
# Ignore common junk
*.log
*.tmp
bin/
obj/
node_modules/
.vscode/
"@ | Out-File -FilePath "$projectPath\.gitignore" -Encoding UTF8

Push-Location $projectPath
if (Get-Command git -ErrorAction SilentlyContinue) {
    git init | Out-Null
    Write-Host "Git repository initialized." -ForegroundColor Green
} else {
    Write-Host "Git not found - skipped git init." -ForegroundColor Yellow
}
Pop-Location

Write-Host "Project '$Name' created at $projectPath" -ForegroundColor Green