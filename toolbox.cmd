@echo off
:: ============================================================
:: toolbox.cmd - Master task dispatcher
:: Usage:
::   toolbox.cmd taskname [args...]
::   toolbox.cmd task1 task2 task3          (run multiple in sequence)
::   toolbox.cmd killtask chrome.exe        (task with its own args)
::   toolbox.cmd list                       (show all available tasks)
:: ============================================================
setlocal enabledelayedexpansion
if "%~1"=="" goto :help
if /i "%~1"=="help" goto :help
if /i "%~1"=="list" goto :help
:parse
if "%~1"=="" goto :alldone
set "task=%~1"
shift
:: ---- tasks that consume extra parameters ----
if /i "%task%"=="backup" (
    call :backup "%~1" "%~2"
    shift & shift
    goto parse
)
if /i "%task%"=="shutdowntimer" (
    call :shutdowntimer "%~1"
    shift
    goto parse
)
if /i "%task%"=="killtask" (
    call :killtask "%~1"
    shift
    goto parse
)
if /i "%task%"=="rename" (
    call :rename "%~1" "%~2"
    shift & shift
    goto parse
)
if /i "%task%"=="countfiles" (
    call :countfiles "%~1"
    shift
    goto parse
)
if /i "%task%"=="findbyext" (
    call :findbyext "%~1" "%~2"
    shift & shift
    goto parse
)
if /i "%task%"=="comparefolders" (
    call :comparefolders "%~1" "%~2"
    shift & shift
    goto parse
)
if /i "%task%"=="setreadonly" (
    call :setreadonly "%~1"
    shift
    goto parse
)
if /i "%task%"=="sethidden" (
    call :sethidden "%~1"
    shift
    goto parse
)
if /i "%task%"=="startservice" (
    call :startservice "%~1"
    shift
    goto parse
)
if /i "%task%"=="stopservice" (
    call :stopservice "%~1"
    shift
    goto parse
)
if /i "%task%"=="createtask" (
    call :createtask "%~1" "%~2" "%~3"
    shift & shift & shift
    goto parse
)
if /i "%task%"=="deletetask" (
    call :deletetask "%~1"
    shift
    goto parse
)
if /i "%task%"=="autolock" (
    call :autolock "%~1"
    shift
    goto parse
)
if /i "%task%"=="pinglog" (
    call :pinglog "%~1"
    shift
    goto parse
)
if /i "%task%"=="mapdrive" (
    call :mapdrive "%~1" "%~2"
    shift & shift
    goto parse
)
if /i "%task%"=="unmapdrive" (
    call :unmapdrive "%~1"
    shift
    goto parse
)
if /i "%task%"=="firewallblock" (
    call :firewallblock "%~1"
    shift
    goto parse
)
if /i "%task%"=="firewallunblock" (
    call :firewallunblock "%~1"
    shift
    goto parse
)
if /i "%task%"=="enableuser" (
    call :enableuser "%~1"
    shift
    goto parse
)
if /i "%task%"=="disableuser" (
    call :disableuser "%~1"
    shift
    goto parse
)
if /i "%task%"=="forcepwchange" (
    call :forcepwchange "%~1"
    shift
    goto parse
)
:: ---- zero-argument tasks ----
call :%task% 2>nul
if errorlevel 1 echo [!] Unknown task: %task%
goto parse
:alldone
echo.
echo ==== All requested tasks complete. ====
goto :eof
:: ============================================================
:: SYSTEM MAINTENANCE
:: ============================================================
:flushdns
echo [flushdns] Flushing DNS, renewing IP, resetting Winsock...
ipconfig /flushdns
ipconfig /release
ipconfig /renew
netsh winsock reset
echo [flushdns] Done. Restart may be needed for Winsock reset.
goto :eof
:cleartemp
echo [cleartemp] Clearing temp folders...
del /q /f /s "%TEMP%\*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1
echo [cleartemp] Done.
goto :eof
:emptybin
echo [emptybin] Emptying Recycle Bin...
rd /s /q C:\$Recycle.Bin >nul 2>&1
echo [emptybin] Done (admin rights may be required for full effect).
goto :eof
:restartexplorer
echo [restartexplorer] Restarting Explorer...
taskkill /f /im explorer.exe
start explorer.exe
echo [restartexplorer] Done.
goto :eof
:sleep
echo [sleep] Sleeping now...
rundll32.exe powrprof.dll,SetSuspendState 0,1,0
goto :eof
:lockpc
echo [lockpc] Locking workstation...
rundll32.exe user32.dll,LockWorkStation
goto :eof
:logoff
echo [logoff] Logging off current user...
shutdown /l
goto :eof
:cancelshutdown
shutdown /a
if errorlevel 1 (echo [cancelshutdown] No shutdown was pending.) else (echo [cancelshutdown] Pending shutdown cancelled.)
goto :eof
:adminrights
net session >nul 2>&1
if %errorlevel% == 0 (echo [adminrights] This session HAS admin rights.) else (echo [adminrights] This session does NOT have admin rights.)
goto :eof
:: ============================================================
:: NETWORK
:: ============================================================
:checkconn
echo [checkconn] Monitoring connection. Press Ctrl+C to stop.
:checkconn_loop
ping -n 1 1.1.1.1 >nul
if errorlevel 1 (echo %date% %time% - Connection DOWN) else (echo %date% %time% - Connection UP)
timeout /t 5 /nobreak >nul
goto checkconn_loop
:showip
echo [showip] Gathering network info...
set OUTFILE=%USERPROFILE%\Desktop\ip_info.txt
ipconfig /all > "%OUTFILE%"
type "%OUTFILE%"
echo [showip] Saved to %OUTFILE%
goto :eof
:listports
echo [listports] Listening ports and owning process IDs:
netstat -ano | findstr LISTENING
goto :eof
:macaddress
echo [macaddress] MAC addresses of all adapters:
getmac /v /fo table
goto :eof
:pinglog
if "%~1"=="" (echo [pinglog] Usage: pinglog HOST & goto :eof)
echo [pinglog] Pinging %~1 and logging results...
set PLOG=%USERPROFILE%\Desktop\ping_%~1.txt
ping -n 10 %~1 > "%PLOG%"
type "%PLOG%"
echo [pinglog] Saved to %PLOG%
goto :eof
:mapdrive
if "%~1"=="" (echo [mapdrive] Usage: mapdrive LETTER \\server\share & goto :eof)
echo [mapdrive] Mapping %~1 to %~2...
net use %~1 %~2 /persistent:yes
goto :eof
:unmapdrive
if "%~1"=="" (echo [unmapdrive] Usage: unmapdrive LETTER & goto :eof)
echo [unmapdrive] Removing mapped drive %~1...
net use %~1 /delete
goto :eof
:firewallblock
if "%~1"=="" (echo [firewallblock] Usage: firewallblock IPADDRESS & goto :eof)
echo [firewallblock] Blocking %~1 via Windows Firewall (admin required)...
netsh advfirewall firewall add rule name="Block_%~1" dir=in action=block remoteip=%~1
netsh advfirewall firewall add rule name="Block_%~1_out" dir=out action=block remoteip=%~1
goto :eof
:firewallunblock
if "%~1"=="" (echo [firewallunblock] Usage: firewallunblock IPADDRESS & goto :eof)
echo [firewallunblock] Removing firewall block for %~1...
netsh advfirewall firewall delete rule name="Block_%~1"
netsh advfirewall firewall delete rule name="Block_%~1_out"
goto :eof
:: ============================================================
:: FILE / FOLDER MANAGEMENT
:: ============================================================
:backup
if "%~1"=="" (echo [backup] Usage: backup "Source" "DestRoot" & goto :eof)
for %%F in (%1) do set FOLDERNAME=%%~nxF
set TS=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%
set TS=%TS: =0%
set DEST=%~2\%FOLDERNAME%_Backup_%TS%
echo [backup] Backing up %1 to "%DEST%"...
robocopy %1 "%DEST%" /E /R:2 /W:5
echo [backup] Done: %DEST%
goto :eof
:rename
if "%~1"=="" (echo [rename] Usage: rename "Folder" "prefix_" & goto :eof)
pushd %1
for %%f in (*) do ren "%%f" "%~2%%f"
popd
echo [rename] Done. Files in %1 prefixed with %~2
goto :eof
:countfiles
set CPATH=%~1
if "%CPATH%"=="" set CPATH=.
echo [countfiles] Counting files in %CPATH% ...
dir "%CPATH%" /s /a-d | find "File(s)"
goto :eof
:findbyext
if "%~1"=="" (echo [findbyext] Usage: findbyext "Path" ".ext" & goto :eof)
echo [findbyext] Searching %1 for *%~2 files...
dir "%~1\*%~2" /s /b
goto :eof
:comparefolders
if "%~1"=="" (echo [comparefolders] Usage: comparefolders "FolderA" "FolderB" & goto :eof)
echo [comparefolders] Comparing %1 vs %2 (list-only, no changes made)...
robocopy %1 %2 /L /E /NJH /NJS
goto :eof
:setreadonly
if "%~1"=="" (echo [setreadonly] Usage: setreadonly "Path" & goto :eof)
echo [setreadonly] Setting read-only attribute on %1 ...
attrib +r "%~1" /s /d
echo [setreadonly] Done.
goto :eof
:sethidden
if "%~1"=="" (echo [sethidden] Usage: sethidden "Path" & goto :eof)
echo [sethidden] Hiding %1 ...
attrib +h "%~1" /s /d
echo [sethidden] Done.
goto :eof
:: ============================================================
:: PROCESS / SERVICE MANAGEMENT
:: ============================================================
:killtask
if "%~1"=="" (echo [killtask] Usage: killtask ProcessName.exe & goto :eof)
echo [killtask] Killing %~1...
taskkill /f /im %~1
goto :eof
:listservices
echo [listservices] Currently running services:
net start
goto :eof
:startservice
if "%~1"=="" (echo [startservice] Usage: startservice ServiceName & goto :eof)
echo [startservice] Starting %~1 (admin required)...
net start "%~1"
goto :eof
:stopservice
if "%~1"=="" (echo [stopservice] Usage: stopservice ServiceName & goto :eof)
echo [stopservice] Stopping %~1 (admin required)...
net stop "%~1"
goto :eof
:: ============================================================
:: SCHEDULING / AUTOMATION
:: ============================================================
:shutdowntimer
if "%~1"=="" (echo [shutdowntimer] Usage: shutdowntimer MINUTES & goto :eof)
set /a SECS=%~1*60
echo [shutdowntimer] Shutdown scheduled in %~1 minute(s). Run "toolbox.cmd cancelshutdown" to abort.
shutdown /s /t %SECS%
goto :eof
:autolock
if "%~1"=="" (echo [autolock] Usage: autolock MINUTES & goto :eof)
set /a WAITSECS=%~1*60
echo [autolock] Locking workstation in %~1 minute(s)...
timeout /t %WAITSECS% /nobreak >nul
rundll32.exe user32.dll,LockWorkStation
goto :eof
:createtask
if "%~1"=="" (echo [createtask] Usage: createtask "TaskName" "HH:MM" "C:\path\to\program.exe" & goto :eof)
echo [createtask] Creating scheduled task %1 at %2 running %3 (admin required)...
schtasks /create /tn %1 /tr %3 /sc daily /st %2
goto :eof
:deletetask
if "%~1"=="" (echo [deletetask] Usage: deletetask "TaskName" & goto :eof)
echo [deletetask] Deleting scheduled task %1 ...
schtasks /delete /tn %1 /f
goto :eof
:listtasks
echo [listtasks] Scheduled tasks:
schtasks /query /fo table
goto :eof
:: ============================================================
:: USER ACCOUNTS (admin required)
:: ============================================================
:listusers
echo [listusers] Local user accounts:
net user
goto :eof
:enableuser
if "%~1"=="" (echo [enableuser] Usage: enableuser Username & goto :eof)
echo [enableuser] Enabling %~1 (admin required)...
net user %~1 /active:yes
goto :eof
:disableuser
if "%~1"=="" (echo [disableuser] Usage: disableuser Username & goto :eof)
echo [disableuser] Disabling %~1 (admin required)...
net user %~1 /active:no
goto :eof
:forcepwchange
if "%~1"=="" (echo [forcepwchange] Usage: forcepwchange Username & goto :eof)
echo [forcepwchange] Forcing password change for %~1 (admin required)...
net user %~1 /logonpasswordchg:yes
goto :eof
:: ============================================================
:: HARDWARE / SYSTEM INFO
:: ============================================================
:gpuinfo
echo [gpuinfo] Graphics adapter info:
wmic path win32_videocontroller get name,driverversion,adapterram
goto :eof
:raminfo
echo [raminfo] RAM slot info:
wmic memorychip get capacity,speed,manufacturer
goto :eof
:biosinfo
echo [biosinfo] BIOS / motherboard info:
wmic bios get smbiosbiosversion,manufacturer,releasedate
wmic baseboard get product,manufacturer
goto :eof
:listprograms
echo [listprograms] Installed programs (this can take a minute)...
wmic product get name,version
goto :eof
:: ============================================================
:: MISC UTILITIES
:: ============================================================
:screenshot
echo [screenshot] Capturing screen...
set SSFILE=%USERPROFILE%\Desktop\screenshot_%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%.png
set SSFILE=%SSFILE: =0%
powershell -command "Add-Type -AssemblyName System.Windows.Forms,System.Drawing; $b=[System.Windows.Forms.SystemInformation]::VirtualScreen; $bmp=New-Object System.Drawing.Bitmap $b.Width,$b.Height; $g=[System.Drawing.Graphics]::FromImage($bmp); $g.CopyFromScreen($b.Left,$b.Top,0,0,$bmp.Size); $bmp.Save('%SSFILE%')"
echo [screenshot] Saved to %SSFILE%
goto :eof
:clip2file
echo [clip2file] Saving clipboard content to file...
set CLIPFILE=%USERPROFILE%\Desktop\clipboard_%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%.txt
set CLIPFILE=%CLIPFILE: =0%
powershell -command "Get-Clipboard | Out-File -FilePath '%CLIPFILE%' -Encoding UTF8"
echo [clip2file] Saved to %CLIPFILE%
goto :eof
:devmgmt
start devmgmt.msc
goto :eof
:diskmgmt
start diskmgmt.msc
goto :eof
:controlpanel
start control
goto :eof
:openworkspace
echo [openworkspace] Launching workspace apps (edit paths inside this script)...
start "" "C:\Program Files\Microsoft VS Code\Code.exe"
start "" "C:\Program Files\Slack\slack.exe"
start "" chrome.exe "https://mail.google.com"
start "" chrome.exe "https://github.com"
goto :eof
:: ============================================================
:: HELP
:: ============================================================
:help
echo.
echo ==============================================
echo  toolbox.cmd - available tasks
echo ==============================================
echo.
echo Usage: toolbox.cmd task1 [args] task2 [args] ...
echo.
echo --- System Maintenance ---
echo   flushdns              cleartemp              emptybin
echo   restartexplorer       sleep                  lockpc
echo   logoff                cancelshutdown         adminrights
echo   shutdowntimer MIN     autolock MIN
echo.
echo --- Network ---
echo   checkconn             showip                 listports
echo   macaddress            pinglog HOST
echo   mapdrive LETTER PATH  unmapdrive LETTER
echo   firewallblock IP      firewallunblock IP
echo.
echo --- Files / Folders ---
echo   backup "Src" "DestRoot"      rename "Folder" "prefix_"
echo   countfiles "Path"            findbyext "Path" ".ext"
echo   comparefolders "A" "B"       setreadonly "Path"
echo   sethidden "Path"
echo.
echo --- Process / Services (admin) ---
echo   killtask NAME.exe     listservices
echo   startservice NAME     stopservice NAME
echo.
echo --- Scheduling ---
echo   createtask "Name" "HH:MM" "Program.exe"
echo   deletetask "Name"     listtasks
echo.
echo --- User Accounts (admin) ---
echo   listusers             enableuser NAME
echo   disableuser NAME      forcepwchange NAME
echo.
echo --- Hardware / System Info ---
echo   gpuinfo               raminfo
echo   biosinfo              listprograms
echo.
echo --- Misc ---
echo   screenshot             clip2file
echo   devmgmt                diskmgmt        controlpanel
echo   openworkspace
echo.
echo Example (multiple tasks in one run):
echo   toolbox.cmd flushdns cleartemp emptybin
echo.
goto :eof