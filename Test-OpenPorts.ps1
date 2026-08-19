<#
.SYNOPSIS
    Scans a host for open TCP ports within a given range.
.PARAMETER ComputerName
    Target hostname or IP address.
.PARAMETER StartPort
    First port in range. Defaults to 1.
.PARAMETER EndPort
    Last port in range. Defaults to 1024.
.PARAMETER TimeoutMs
    Connection timeout per port in milliseconds. Defaults to 200.
.EXAMPLE
    .\Test-OpenPorts.ps1 -ComputerName "192.168.1.1" -StartPort 1 -EndPort 1000
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName,

    [int]$StartPort = 1,
    [int]$EndPort = 1024,
    [int]$TimeoutMs = 200
)

Write-Host "Scanning $ComputerName ports $StartPort-$EndPort..." -ForegroundColor Cyan
$openPorts = @()

for ($port = $StartPort; $port -le $EndPort; $port++) {
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $connect = $client.BeginConnect($ComputerName, $port, $null, $null)
        $success = $connect.AsyncWaitHandle.WaitOne($TimeoutMs, $false)

        if ($success -and $client.Connected) {
            Write-Host "Port $port: OPEN" -ForegroundColor Green
            $openPorts += $port
        }
    } catch {
        # closed/filtered, ignore
    } finally {
        $client.Close()
    }
}

Write-Host "`nScan complete. $($openPorts.Count) open ports found: $($openPorts -join ', ')" -ForegroundColor Cyan
Write-Host "Note: Only scan hosts you own or have permission to test." -ForegroundColor Yellow