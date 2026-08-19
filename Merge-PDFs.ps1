<#
.SYNOPSIS
    Merges multiple PDFs in a folder into a single PDF, in filename order.
.DESCRIPTION
    Requires PDFtk or Ghostscript-based tooling is NOT used here; instead uses
    the free 'PdfMerger' approach via .NET is complex, so this uses pdftk if available,
    falling back to instructions if not installed.
.PARAMETER Path
    Folder containing the PDFs to merge (sorted alphabetically).
.PARAMETER OutputFile
    Path for the merged output PDF.
.EXAMPLE
    .\Merge-PDFs.ps1 -Path "C:\Reports" -OutputFile "C:\Reports\Combined.pdf"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [Parameter(Mandatory=$true)]
    [string]$OutputFile
)

if (-not (Get-Command pdftk -ErrorAction SilentlyContinue)) {
    Write-Host "pdftk is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Install it with: winget install PDFLabs.PDFtk" -ForegroundColor Yellow
    exit 1
}

$pdfs = Get-ChildItem -Path $Path -Filter "*.pdf" | Sort-Object Name

if ($pdfs.Count -eq 0) {
    Write-Host "No PDF files found in $Path" -ForegroundColor Red
    exit 1
}

Write-Host "Merging $($pdfs.Count) PDFs..." -ForegroundColor Cyan
$pdfs | ForEach-Object { Write-Host " - $($_.Name)" }

$fileList = $pdfs.FullName -join " "
& pdftk $pdfs.FullName cat output $OutputFile

if (Test-Path $OutputFile) {
    Write-Host "`nMerged PDF saved to: $OutputFile" -ForegroundColor Green
} else {
    Write-Host "Merge failed." -ForegroundColor Red
}