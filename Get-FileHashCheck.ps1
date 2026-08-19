<#
.SYNOPSIS
    Computes and optionally verifies file hashes (checksums) - useful for verifying downloads.
.PARAMETER Path
    File to hash.
.PARAMETER Algorithm
    Hash algorithm: MD5, SHA1, SHA256, SHA512. Defaults to SHA256.
.PARAMETER CompareTo
    Optional expected hash value to compare against.
.EXAMPLE
    .\Get-FileHashCheck.ps1 -Path "C:\Downloads\installer.exe"
    .\Get-FileHashCheck.ps1 -Path "C:\Downloads\installer.exe" -CompareTo "ABC123..." -Algorithm SHA256
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [ValidateSet("MD5", "SHA1", "SHA256", "SHA512")]
    [string]$Algorithm = "SHA256",

    [string]$CompareTo
)

if (-not (Test-Path $Path)) {
    Write-Host "File not found: $Path" -ForegroundColor Red
    exit 1
}

$hash = Get-FileHash -Path $Path -Algorithm $Algorithm
Write-Host "$Algorithm hash for $(Split-Path $Path -Leaf):" -ForegroundColor Cyan
Write-Host $hash.Hash

if ($CompareTo) {
    if ($hash.Hash -eq $CompareTo.ToUpper()) {
        Write-Host "`nMATCH - file integrity verified." -ForegroundColor Green
    } else {
        Write-Host "`nMISMATCH - file may be corrupted or tampered with!" -ForegroundColor Red
    }
}