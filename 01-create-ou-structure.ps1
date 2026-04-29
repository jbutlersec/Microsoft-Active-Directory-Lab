<# 
LA Lakers AD
Script: 01-create-ou-structure.ps1
Purpose: Creates Active Directory OU structure from CSV.

Expected CSV:
C:\LA Lakers AD\CSV\01-ou-structure.csv

Expected columns:
OUName,ParentOU,Description
#>

Import-Module ActiveDirectory

$CsvPath = "C:\LA Lakers AD\CSV\01-ou-structure.csv"
$DomainDN = (Get-ADDomain).DistinguishedName

if (!(Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

$OUs = Import-Csv $CsvPath

foreach ($OU in $OUs) {
    $Name = $OU.OUName.Trim()
    $ParentOU = $OU.ParentOU.Trim()
    $Description = $OU.Description

    if ([string]::IsNullOrWhiteSpace($ParentOU)) {
        $Path = $DomainDN
    }
    else {
        $Parent = Get-ADOrganizationalUnit -Filter "Name -eq '$ParentOU'" -SearchBase $DomainDN -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -eq $Parent) {
            Write-Warning "Parent OU '$ParentOU' was not found. Skipping OU '$Name'."
            continue
        }
        $Path = $Parent.DistinguishedName
    }

    $ExistingOU = Get-ADOrganizationalUnit -Filter "Name -eq '$Name'" -SearchBase $Path -ErrorAction SilentlyContinue

    if ($ExistingOU) {
        Write-Host "OU already exists: $Name"
    }
    else {
        New-ADOrganizationalUnit -Name $Name -Path $Path -Description $Description -ProtectedFromAccidentalDeletion $true
        Write-Host "Created OU: $Name"
    }
}
