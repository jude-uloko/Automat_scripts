@echo off
:: Clears user and system temp folders
echo Clearing user temp folder...
del /q /f /s "%TEMP%\*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1

echo Clearing Windows temp folder...
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1

echo.
echo Temp folders cleared.
pause