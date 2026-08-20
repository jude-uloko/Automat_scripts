@echo off
:: Empties the Recycle Bin for all drives
echo Emptying Recycle Bin...
rd /s /q C:\$Recycle.Bin >nul 2>&1

echo Recycle Bin emptied (may require admin rights for full effect).
pause