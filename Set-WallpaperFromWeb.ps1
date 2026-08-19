<#
.SYNOPSIS
    Downloads a random image and sets it as the desktop wallpaper.
.DESCRIPTION
    Uses Picsum Photos (free, no API key needed) for random high-quality images.
.PARAMETER Width
    Wallpaper width in pixels. Defaults to 1920.
.PARAMETER Height
    Wallpaper height in pixels. Defaults to 1080.
.EXAMPLE
    .\Set-WallpaperFromWeb.ps1
    .\Set-WallpaperFromWeb.ps1 -Width 2560 -Height 1440
#>

param(
    [int]$Width = 1920,
    [int]$Height = 1080
)

$imageUrl = "https://picsum.photos/$Width/$Height"
$savePath = "$env:USERPROFILE\Pictures\Wallpaper_$(Get-Date -Format 'yyyyMMdd_HHmmss').jpg"

Write-Host "Downloading random wallpaper..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $imageUrl -OutFile $savePath -UseBasicParsing
} catch {
    Write-Host "Failed to download image: $_" -ForegroundColor Red
    exit 1
}

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

$SPI_SETDESKWALLPAPER = 20
$UPDATE_INI_FILE = 0x01
$SEND_CHANGE = 0x02

[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $savePath, $UPDATE_INI_FILE -bor $SEND_CHANGE)

Write-Host "Wallpaper set from: $savePath" -ForegroundColor Green