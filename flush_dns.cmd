@echo off
:: Flushes DNS cache and renews network connection - fixes common connectivity issues
echo Flushing DNS cache...
ipconfig /flushdns

echo Releasing IP address...
ipconfig /release

echo Renewing IP address...
ipconfig /renew

echo.
echo Resetting Winsock catalog...
netsh winsock reset

echo.
echo Done. A restart may be required for the Winsock reset to fully apply.
pause