<# 
LA Lakers AD
Script: 00-setup-folder-and-execution-policy.ps1
Purpose: Creates lab folders and sets PowerShell execution policy to RemoteSigned.

Run PowerShell as Administrator.
#>

New-Item -ItemType Directory -Path "C:\LA Lakers AD" -Force | Out-Null
New-Item -ItemType Directory -Path "C:\LA Lakers AD\CSV" -Force | Out-Null
New-Item -ItemType Directory -Path "C:\LA Lakers AD\Scripts" -Force | Out-Null
New-Item -ItemType Directory -Path "C:\LA Lakers AD\Reports" -Force | Out-Null
New-Item -ItemType Directory -Path "C:\LA Lakers AD\Shares" -Force | Out-Null

Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

Write-Host "Created C:\LA Lakers AD folder structure."
Write-Host "PowerShell execution policy set to RemoteSigned for LocalMachine."
