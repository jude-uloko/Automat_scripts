<div align="center">

# ⚡ Windows Automation Toolkit

**A personal collection of PowerShell and CMD scripts for everyday automation, system maintenance, and getting things done fast.**

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat&logo=powershell&logoColor=white)
![CMD](https://img.shields.io/badge/CMD-Batch-4D4D4D?style=flat&logo=windowsterminal&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?style=flat&logo=windows&logoColor=white)
![Scripts](https://img.shields.io/badge/Scripts-56+-brightgreen?style=flat)

</div>

---

## 📁 Repo Structure

All scripts sit flat at the repo root — clone it, and everything is one folder deep.

```
.
├── toolbox.cmd              All-in-one CMD dispatcher — run any task by name
├── toolbox_README.md        Full usage guide for the dispatcher
├── *.ps1                    40 standalone PowerShell scripts
├── *.cmd                    16 standalone CMD scripts
└── README.md                You are here
```

## 🚀 Quick Start

**PowerShell scripts** — run individually from the repo root:
```powershell
.\Clean-System.ps1
.\Backup-Folder.ps1 -SourcePath "C:\Projects\MyApp" -DestinationPath "D:\Backups"
```

**CMD scripts** — run one command for anything, single or chained:
```cmd
toolbox.cmd flushdns cleartemp emptybin
toolbox.cmd killtask chrome.exe
toolbox.cmd help
```

> If PowerShell scripts are blocked from running, allow them for your session:
> ```powershell
> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
> ```

---

## 🧰 PowerShell Scripts

<details>
<summary><strong>System Maintenance</strong></summary>

| Script | Description |
|---|---|
| `Clean-System.ps1` | Clears temp files, recycle bin, browser caches. Logs space freed. |
| `Get-SystemInfo.ps1` | Reports CPU, RAM, disk, and network info to console + file. |
| `Check-DiskHealth.ps1` | Checks SMART health status of all physical drives. |
| `Check-WindowsUpdates.ps1` | Checks for available Windows updates. |
| `Get-BatteryHealth.ps1` | Generates and opens a Windows battery health report. |
| `Get-UptimeReport.ps1` | Reports current uptime and recent shutdown/restart history. |
| `Get-EventLogErrors.ps1` | Pulls recent Critical/Error events from Windows Event Viewer. |
| `List-StartupPrograms.ps1` | Lists all programs configured to run at startup. |
| `Watch-ProcessCPU.ps1` | Logs top CPU/RAM-consuming processes at intervals. |
| `Toggle-DarkMode.ps1` | Switches Windows between light/dark theme. |

</details>

<details>
<summary><strong>Files & Folders</strong></summary>

| Script | Description |
|---|---|
| `Backup-Folder.ps1` | Zips a folder into a date-stamped backup archive. |
| `Sync-Folders.ps1` | Syncs/mirrors one folder to another using Robocopy. |
| `Find-LargeFiles.ps1` | Scans a path and lists the largest files, exports to CSV. |
| `Find-DuplicateFiles.ps1` | Finds duplicate files by content hash, with optional auto-delete. |
| `Get-FileHashCheck.ps1` | Computes/verifies file checksums (MD5, SHA1, SHA256, SHA512). |
| `Remove-EmptyFolders.ps1` | Recursively finds/removes empty folders (supports `-WhatIf`). |
| `Rename-BatchFiles.ps1` | Bulk renames files: prefix/suffix or sequential numbering. |
| `Rename-MediaByDate.ps1` | Renames photos/videos using EXIF or file creation date. |
| `Sort-DownloadsFolder.ps1` | Auto-sorts a folder's files into subfolders by type. |
| `Extract-Archives.ps1` | Extracts all .zip files in a folder into their own subfolders. |
| `Compress-Images.ps1` | Bulk resizes/compresses images to reduce file size. |
| `Merge-PDFs.ps1` | Merges all PDFs in a folder into one, using pdftk. |
| `Watch-Folder.ps1` | Watches a folder and auto-moves new files as they arrive. |

</details>

<details>
<summary><strong>Dev Workflow</strong></summary>

| Script | Description |
|---|---|
| `New-ProjectFolder.ps1` | Scaffolds a new project folder (src/docs/tests, README, git init). |
| `Git-QuickCommit.ps1` | Adds, commits, and pushes git changes in one command. |
| `Clone-AllRepos.ps1` | Clones a list of git repos from a text file. |
| `Install-DevTools.ps1` | Installs a standard dev toolkit (Git, VS Code, Node, Python, etc.) via winget. |
| `Set-EnvVars.ps1` | Sets environment variables in bulk from a simple config file. |
| `Backup-DotFiles.ps1` | Backs up PowerShell profile, VS Code settings, git config, etc. |

</details>

<details>
<summary><strong>Network</strong></summary>

| Script | Description |
|---|---|
| `Test-InternetConnection.ps1` | Monitors connectivity, logs downtime with timestamps. |
| `Get-PublicIP.ps1` | Shows your public IP and basic geolocation. |
| `Test-OpenPorts.ps1` | Scans a host for open TCP ports in a given range. |
| `Get-WifiPasswords.ps1` | Shows saved WiFi networks and their passwords (admin required). |
| `Get-USBDeviceHistory.ps1` | Lists currently connected and historical USB devices. |

</details>

<details>
<summary><strong>Security & Backups</strong></summary>

| Script | Description |
|---|---|
| `New-SecurePassword.ps1` | Generates cryptographically random strong passwords. |
| `Backup-Registry.ps1` | Exports a registry key or full registry backup before risky changes. |

</details>

<details>
<summary><strong>Productivity & Misc</strong></summary>

| Script | Description |
|---|---|
| `Start-WorkSession.ps1` | Launches your usual work apps and browser tabs at once. |
| `Remind-Me.ps1` | Shows a popup reminder after a delay or at a specific time. |
| `Set-WallpaperFromWeb.ps1` | Downloads a random image and sets it as desktop wallpaper. |
| `Export-OutlookAttachments.ps1` | Saves all email attachments from an Outlook folder locally. |

</details>

### PowerShell Usage Examples

```powershell
.\Backup-Folder.ps1 -SourcePath "C:\Projects\MyApp" -DestinationPath "D:\Backups"
.\Find-LargeFiles.ps1 -Path "D:\" -Top 30
.\New-SecurePassword.ps1 -Length 20 -Count 5
.\Merge-PDFs.ps1 -Path "C:\Reports" -OutputFile "C:\Reports\Combined.pdf"
.\Watch-Folder.ps1 -Path "C:\Scans" -DestinationPath "C:\Scans\Processed"
```

Every script has a full help entry:
```powershell
Get-Help .\ScriptName.ps1 -Full
```

### Dependencies

| Script | Requires |
|---|---|
| `Merge-PDFs.ps1` | [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) — `winget install PDFLabs.PDFtk` |
| `Install-DevTools.ps1` | `winget` (built into modern Windows 10/11) |
| `Export-OutlookAttachments.ps1` | Outlook desktop app installed |
| `Get-WifiPasswords.ps1` | Must be run as Administrator |

Edit the placeholder app/URL/config lists inside `Start-WorkSession.ps1` and `Backup-DotFiles.ps1` before running.

---

## 🖥️ CMD Scripts

All CMD tasks now live in **one dispatcher**: `toolbox.cmd`. Call any task by name, chain multiple together, and pass arguments where needed. Standalone `.cmd` versions of the original scripts are still included at the repo root.

```cmd
toolbox.cmd flushdns cleartemp emptybin
toolbox.cmd killtask chrome.exe
toolbox.cmd backup "C:\Projects\MyApp" "D:\Backups"
toolbox.cmd help
```

<details>
<summary><strong>Full task list by category</strong></summary>

**System Maintenance**
`flushdns` · `cleartemp` · `emptybin` · `restartexplorer` · `sleep` · `lockpc` · `logoff` · `cancelshutdown` · `adminrights` · `shutdowntimer MIN` · `autolock MIN`

**Network**
`checkconn` · `showip` · `listports` · `macaddress` · `pinglog HOST` · `mapdrive LETTER PATH` · `unmapdrive LETTER` · `firewallblock IP` · `firewallunblock IP`

**Files / Folders**
`backup "Src" "DestRoot"` · `rename "Folder" "prefix_"` · `countfiles "Path"` · `findbyext "Path" ".ext"` · `comparefolders "A" "B"` · `setreadonly "Path"` · `sethidden "Path"`

**Process / Services** *(admin)*
`killtask NAME.exe` · `listservices` · `startservice NAME` · `stopservice NAME`

**Scheduling**
`createtask "Name" "HH:MM" "Program.exe"` · `deletetask "Name"` · `listtasks`

**User Accounts** *(admin)*
`listusers` · `enableuser NAME` · `disableuser NAME` · `forcepwchange NAME`

**Hardware / System Info**
`gpuinfo` · `raminfo` · `biosinfo` · `listprograms`

**Misc**
`screenshot` · `clip2file` · `devmgmt` · `diskmgmt` · `controlpanel` · `openworkspace`

</details>

---

## ⚠️ Safety Notes

- **Admin required** for: `Get-WifiPasswords.ps1`, CMD `firewallblock`/`firewallunblock`, `startservice`/`stopservice`, `enableuser`/`disableuser`/`forcepwchange`.
- **Scans/network** — `Test-OpenPorts.ps1` and similar should only target hosts you own or have permission to test.
- **Destructive by design** — review before running on important data: `Clean-System.ps1`, `Remove-EmptyFolders.ps1`, `Sort-DownloadsFolder.ps1`, `Find-DuplicateFiles.ps1 -DeleteDuplicates`, `Sync-Folders.ps1 -Mirror`, and any CMD task that deletes, kills, or shuts down (`backup`, `rename`, `killtask`, account/service management).
- **wmic deprecation** — CMD's `gpuinfo`, `raminfo`, `biosinfo`, `listprograms` rely on `wmic`, which Microsoft is phasing out on newer Windows builds.
- `Get-WifiPasswords.ps1` and CMD equivalents reveal saved passwords in plain text — only run locally, be careful sharing output.


