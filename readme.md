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
```

Check each script's header comment (`Get-Help .\ScriptName.ps1 -Full`) for full parameter details.

## Note on Execution Policy

If scripts are blocked from running, you may need to allow local scripts for your session:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## Disclaimer

Scripts that delete, move, or modify files (`Clean-System.ps1`, `Remove-EmptyFolders.ps1`, `Sort-DownloadsFolder.ps1`, etc.) should be reviewed before running on important data. Consider testing on a non-critical folder first.
