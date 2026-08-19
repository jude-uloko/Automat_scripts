<#
.SYNOPSIS
    Bulk resizes/compresses images in a folder using .NET System.Drawing.
.PARAMETER Path
    Folder containing images to compress.
.PARAMETER OutputPath
    Folder to save compressed images. Defaults to a "Compressed" subfolder.
.PARAMETER MaxWidth
    Max width in pixels; image is scaled down proportionally if larger. Defaults to 1920.
.PARAMETER Quality
    JPEG quality (1-100). Defaults to 75.
.EXAMPLE
    .\Compress-Images.ps1 -Path "C:\Photos" -MaxWidth 1600 -Quality 80
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [string]$OutputPath = (Join-Path $Path "Compressed"),
    [int]$MaxWidth = 1920,
    [int]$Quality = 75
)

Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

$extensions = @(".jpg", ".jpeg", ".png", ".bmp")
$images = Get-ChildItem -Path $Path -File | Where-Object { $extensions -contains $_.Extension.ToLower() }

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $Quality)
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }

foreach ($img in $images) {
    try {
        $bitmap = [System.Drawing.Image]::FromFile($img.FullName)

        $ratio = [math]::Min(1, $MaxWidth / $bitmap.Width)
        $newWidth = [int]($bitmap.Width * $ratio)
        $newHeight = [int]($bitmap.Height * $ratio)

        $resized = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        $graphics = [System.Drawing.Graphics]::FromImage($resized)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($bitmap, 0, 0, $newWidth, $newHeight)

        $outFile = Join-Path $OutputPath $img.Name
        $resized.Save($outFile, $jpegCodec, $encoderParams)

        $graphics.Dispose()
        $resized.Dispose()
        $bitmap.Dispose()

        $origKB = [math]::Round($img.Length / 1KB, 1)
        $newKB = [math]::Round((Get-Item $outFile).Length / 1KB, 1)
        Write-Host "$($img.Name): $origKB KB -> $newKB KB" -ForegroundColor Green
    } catch {
        Write-Host "Failed to process $($img.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`nDone. Compressed images saved to $OutputPath" -ForegroundColor Cyan