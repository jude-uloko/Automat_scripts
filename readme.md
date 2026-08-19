# PowerShell Scripts

A collection of PowerShell scripts for everyday automation and productivity.

## Scripts

| Script | Description |
|---|---|
| `Clean-System.ps1` | Clears temp files, recycle bin, browser caches. Logs space freed. |
| `Get-SystemInfo.ps1` | Reports CPU, RAM, disk, and network info to console + file. |
| `Backup-Folder.ps1` | Zips a folder into a date-stamped backup archive. |
| `Find-LargeFiles.ps1` | Scans a path and lists the largest files, exports to CSV. |
| `New-ProjectFolder.ps1` | Scaffolds a new project folder (src/docs/tests, README, git init). |
| `Test-InternetConnection.ps1` | Monitors connectivity, logs downtime with timestamps. |
| `Rename-BatchFiles.ps1` | Bulk renames files: prefix/suffix or sequential numbering. |
| `Sort-DownloadsFolder.ps1` | Auto-sorts a folder's files into subfolders by type. |
| `Remove-EmptyFolders.ps1` | Recursively finds/removes empty folders (supports -WhatIf). |
| `Git-QuickCommit.ps1` | Adds, commits, and pushes git changes in one command. |
| `Get-PublicIP.ps1` | Shows your public IP and basic geolocation. |
| `New-SecurePassword.ps1` | Generates cryptographically random strong passwords. |
| `Get-BatteryHealth.ps1` | Generates and opens a Windows battery health report. |
| `Toggle-DarkMode.ps1` | Switches Windows between light/dark theme. |
| `List-StartupPrograms.ps1` | Lists all programs configured to run at startup. |
| `Install-DevTools.ps1` | Installs a standard dev toolkit (Git, VS Code, Node, Python, etc.) via winget. |
| `Merge-PDFs.ps1` | Merges all PDFs in a folder into one, using pdftk. |
| `Compress-Images.ps1` | Bulk resizes/compresses images to reduce file size. |
| `Extract-Archives.ps1` | Extracts all .zip files in a folder into their own subfolders. |
| `Rename-MediaByDate.ps1` | Renames photos/videos using EXIF or file creation date. |
| `Get-EventLogErrors.ps1` | Pulls recent Critical/Error events from Windows Event Viewer. |
| `Watch-ProcessCPU.ps1` | Logs top CPU/RAM-consuming processes at intervals. |
| `Watch-Folder.ps1` | Watches a folder and auto-moves new files as they arrive. |
| `Clone-AllRepos.ps1` | Clones a list of git repos from a text file. |
| `Check-DiskHealth.ps1` | Checks SMART health status of all physical drives. |
| `Export-OutlookAttachments.ps1` | Saves all email attachments from an Outlook folder locally. |
| `Set-WallpaperFromWeb.ps1` | Downloads a random image and sets it as desktop wallpaper. |
| `Start-WorkSession.ps1` | Launches your usual work apps and browser tabs at once. |
| `Get-WifiPasswords.ps1` | Shows saved WiFi networks and their passwords (admin required). |
| `Set-EnvVars.ps1` | Sets environment variables in bulk from a simple config file. |
| `Backup-DotFiles.ps1` | Backs up PowerShell profile, VS Code settings, git config, etc. |
| `Remind-Me.ps1` | Shows a popup reminder after a delay or at a specific time. |
| `Get-FileHashCheck.ps1` | Computes/verifies file checksums (MD5, SHA1, SHA256, SHA512). |
| `Find-DuplicateFiles.ps1` | Finds duplicate files by content hash, with optional auto-delete. |
| `Sync-Folders.ps1` | Syncs/mirrors one folder to another using Robocopy. |
| `Test-OpenPorts.ps1` | Scans a host for open TCP ports in a given range. |
| `Backup-Registry.ps1` | Exports a registry key or full registry backup before risky changes. |
| `Check-WindowsUpdates.ps1` | Checks for available Windows updates. |
| `Get-USBDeviceHistory.ps1` | Lists currently connected and historical USB devices. |
| `Get-UptimeReport.ps1` | Reports current uptime and recent shutdown/restart history. |

## Usage

Most scripts can be run directly:

```powershell
.\ScriptName.ps1
```

Some accept parameters, e.g.:

```powershell
.\Backup-Folder.ps1 -SourcePath "C:\Projects\MyApp" -DestinationPath "D:\Backups"
.\Find-LargeFiles.ps1 -Path "D:\" -Top 30
.\New-SecurePassword.ps1 -Length 20 -Count 5
.\Merge-PDFs.ps1 -Path "C:\Reports" -OutputFile "C:\Reports\Combined.pdf"
.\Watch-Folder.ps1 -Path "C:\Scans" -DestinationPath "C:\Scans\Processed"
```

## Dependencies

A few scripts rely on external tools that aren't built into Windows:
- `Merge-PDFs.ps1` requires [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) (`winget install PDFLabs.PDFtk`)
- `Install-DevTools.ps1` requires `winget` (built into modern Windows 10/11)
- `Export-OutlookAttachments.ps1` requires Outlook desktop app installed
- `Get-WifiPasswords.ps1` must be run as Administrator
- Edit the app/URL/config lists inside `Start-WorkSession.ps1` and `Backup-DotFiles.ps1` to match your own setup before running

## Security Note

`Get-WifiPasswords.ps1` reveals saved network passwords in plain text. Only run it on your own machine, and be careful where you save/share the output.

`Test-OpenPorts.ps1` should only be pointed at hosts you own or have explicit permission to scan — scanning networks you don't control may violate terms of service or local law.

`Find-DuplicateFiles.ps1` with `-DeleteDuplicates` and `Sync-Folders.ps1` with `-Mirror` both delete files. Test on a non-critical folder first, or review the log/dry-run output before trusting them on important data.

Check each script's header comment (`Get-Help .\ScriptName.ps1 -Full`) for full parameter details.

## Note on Execution Policy

If scripts are blocked from running, you may need to allow local scripts for your session:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## Disclaimer

Scripts that delete, move, or modify files (`Clean-System.ps1`, `Remove-EmptyFolders.ps1`, `Sort-DownloadsFolder.ps1`, etc.) should be reviewed before running on important data. Consider testing on a non-critical folder first.
