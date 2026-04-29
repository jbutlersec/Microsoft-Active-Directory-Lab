<# 
LA Lakers AD
Script: 05-create-group-nesting.ps1
Purpose: Nests groups inside other groups from CSV.

Expected CSV:
C:\LA Lakers AD\CSV\05-group-nesting.csv

Expected columns:
ChildGroup,ParentGroup
#>

Import-Module ActiveDirectory

$CsvPath = "C:\LA Lakers AD\CSV\05-group-nesting.csv"

if (!(Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

$Nestings = Import-Csv $CsvPath

foreach ($Nesting in $Nestings) {
    $ChildGroupName = $Nesting.ChildGroup.Trim()
    $ParentGroupName = $Nesting.ParentGroup.Trim()

    $ChildGroup = Get-ADGroup -Filter "Name -eq '$ChildGroupName'" -ErrorAction SilentlyContinue
    $ParentGroup = Get-ADGroup -Filter "Name -eq '$ParentGroupName'" -ErrorAction SilentlyContinue

    if ($null -eq $ChildGroup) {
        Write-Warning "Child group not found: $ChildGroupName"
        continue
    }

    if ($null -eq $ParentGroup) {
        Write-Warning "Parent group not found: $ParentGroupName"
        continue
    }

    try {
        Add-ADGroupMember -Identity $ParentGroup -Members $ChildGroup -ErrorAction Stop
        Write-Host "Nested $ChildGroupName into $ParentGroupName"
    }
    catch {
        if ($_.Exception.Message -like "*already a member*") {
            Write-Host "$ChildGroupName is already nested in $ParentGroupName"
        }
        else {
            Write-Warning "Could not nest $ChildGroupName into $ParentGroupName. Error: $($_.Exception.Message)"
        }
    }
}
