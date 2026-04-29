<# 
LA Lakers AD
Script: 04-assign-group-membership.ps1
Purpose: Adds users to AD groups from CSV.

Expected CSV:
C:\LA Lakers AD\CSV\04-group-membership.csv

Expected columns:
SamAccountName,GroupName
#>

Import-Module ActiveDirectory

$CsvPath = "C:\LA Lakers AD\CSV\04-group-membership.csv"

if (!(Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

$Memberships = Import-Csv $CsvPath

foreach ($Membership in $Memberships) {
    $Sam = $Membership.SamAccountName.Trim()
    $GroupName = $Membership.GroupName.Trim()

    $User = Get-ADUser -Filter "SamAccountName -eq '$Sam'" -ErrorAction SilentlyContinue
    $Group = Get-ADGroup -Filter "Name -eq '$GroupName'" -ErrorAction SilentlyContinue

    if ($null -eq $User) {
        Write-Warning "User not found: $Sam"
        continue
    }

    if ($null -eq $Group) {
        Write-Warning "Group not found: $GroupName"
        continue
    }

    try {
        Add-ADGroupMember -Identity $Group -Members $User -ErrorAction Stop
        Write-Host "Added $Sam to $GroupName"
    }
    catch {
        if ($_.Exception.Message -like "*already a member*") {
            Write-Host "$Sam is already a member of $GroupName"
        }
        else {
            Write-Warning "Could not add $Sam to $GroupName. Error: $($_.Exception.Message)"
        }
    }
}
