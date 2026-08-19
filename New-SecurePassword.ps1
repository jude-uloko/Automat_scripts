<#
.SYNOPSIS
    Generates one or more random strong passwords.
.PARAMETER Length
    Password length. Defaults to 16.
.PARAMETER Count
    Number of passwords to generate. Defaults to 1.
.PARAMETER ExcludeSymbols
    If set, excludes special characters (letters + numbers only).
.EXAMPLE
    .\New-SecurePassword.ps1 -Length 20 -Count 5
#>

param(
    [int]$Length = 16,
    [int]$Count = 1,
    [switch]$ExcludeSymbols
)

$lower = 'abcdefghijklmnopqrstuvwxyz'
$upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
$digits = '0123456789'
$symbols = '!@#$%^&*()-_=+[]{}'

$charSet = $lower + $upper + $digits
if (-not $ExcludeSymbols) { $charSet += $symbols }

$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

function New-Password($len, $chars) {
    $bytes = New-Object byte[] $len
    $rng.GetBytes($bytes)
    $password = -join ($bytes | ForEach-Object { $chars[$_ % $chars.Length] })
    return $password
}

for ($i = 1; $i -le $Count; $i++) {
    $pwd = New-Password -len $Length -chars $charSet
    Write-Host $pwd -ForegroundColor Green
}