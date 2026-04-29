<# 
LA Lakers AD
Script: 06-create-shared-folders.ps1
Purpose: Creates shared folders and applies basic NTFS permissions.

Expected CSV:
C:\LA Lakers AD\CSV\06-shares.csv

Expected columns:
ShareName,FolderPath,ReadGroup,ModifyGroup,FullControlGroup
#>

Import-Module ActiveDirectory

$CsvPath = "C:\LA Lakers AD\CSV\06-shares.csv"

if (!(Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

$Shares = Import-Csv $CsvPath

foreach ($Share in $Shares) {
    $ShareName = $Share.ShareName.Trim()
    $FolderPath = $Share.FolderPath.Trim()
    $ReadGroup = $Share.ReadGroup.Trim()
    $ModifyGroup = $Share.ModifyGroup.Trim()
    $FullControlGroup = $Share.FullControlGroup.Trim()

    if (!(Test-Path $FolderPath)) {
        New-Item -ItemType Directory -Path $FolderPath -Force | Out-Null
        Write-Host "Created folder: $FolderPath"
    }

    $Acl = Get-Acl $FolderPath

    $Acl.SetAccessRuleProtection($true, $false)

    $RulesToRemove = @($Acl.Access)
    foreach ($Rule in $RulesToRemove) {
        $Acl.RemoveAccessRule($Rule) | Out-Null
    }

    $AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Domain Admins", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $SystemRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $Acl.AddAccessRule($AdminRule)
    $Acl.AddAccessRule($SystemRule)

    if ($ReadGroup) {
        $ReadRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ReadGroup, "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
        $Acl.AddAccessRule($ReadRule)
    }

    if ($ModifyGroup) {
        $ModifyRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ModifyGroup, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $Acl.AddAccessRule($ModifyRule)
    }

    if ($FullControlGroup) {
        $FullRule = New-Object System.Security.AccessControl.FileSystemAccessRule($FullControlGroup, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $Acl.AddAccessRule($FullRule)
    }

    Set-Acl -Path $FolderPath -AclObject $Acl

    $ExistingShare = Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue

    if ($ExistingShare) {
        Write-Host "SMB share already exists: $ShareName"
    }
    else {
        New-SmbShare -Name $ShareName -Path $FolderPath -ChangeAccess "Authenticated Users" | Out-Null
        Write-Host "Created SMB share: $ShareName"
    }
}
