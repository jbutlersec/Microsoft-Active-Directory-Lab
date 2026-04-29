<# 
LA Lakers AD
Script: 02-create-security-groups.ps1
Purpose: Creates AD security groups from CSV.

Expected CSV:
C:\LA Lakers AD\CSV\03-groups.csv

Expected columns:
GroupName,GroupScope,GroupCategory,OU,Description
#>

Import-Module ActiveDirectory

$CsvPath = "C:\LA Lakers AD\CSV\03-groups.csv"
$DomainDN = (Get-ADDomain).DistinguishedName

if (!(Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

$Groups = Import-Csv $CsvPath

foreach ($Group in $Groups) {
    $GroupName = $Group.GroupName.Trim()
    $Scope = if ($Group.GroupScope) { $Group.GroupScope.Trim() } else { "Global" }
    $Category = if ($Group.GroupCategory) { $Group.GroupCategory.Trim() } else { "Security" }
    $OUName = $Group.OU.Trim()
    $Description = $Group.Description

    $TargetOU = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'" -SearchBase $DomainDN -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($null -eq $TargetOU) {
        Write-Warning "OU '$OUName' not found for group '$GroupName'. Skipping."
        continue
    }

    $ExistingGroup = Get-ADGroup -Filter "Name -eq '$GroupName'" -ErrorAction SilentlyContinue

    if ($ExistingGroup) {
        Write-Host "Group already exists: $GroupName"
    }
    else {
        New-ADGroup `
            -Name $GroupName `
            -SamAccountName $GroupName `
            -GroupScope $Scope `
            -GroupCategory $Category `
            -Path $TargetOU.DistinguishedName `
            -Description $Description

        Write-Host "Created group: $GroupName"
    }
}
