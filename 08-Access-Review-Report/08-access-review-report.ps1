<# 
LA Lakers AD
Script: 08-access-review-report.ps1
Purpose: Exports an access review report showing users, departments, titles, enabled status, and group memberships.

Output:
C:\LA Lakers AD\Reports\access-review-report.csv
#>

Import-Module ActiveDirectory

$ReportFolder = "C:\LA Lakers AD\Reports"
$ReportPath = "$ReportFolder\access-review-report.csv"

if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

$Users = Get-ADUser -Filter * -Properties Department,Title,Enabled,MemberOf,Description | Sort-Object SamAccountName

$Report = foreach ($User in $Users) {
    $Groups = @()

    foreach ($GroupDN in $User.MemberOf) {
        try {
            $Groups += (Get-ADGroup -Identity $GroupDN).Name
        }
        catch {
            $Groups += $GroupDN
        }
    }

    [PSCustomObject]@{
        SamAccountName = $User.SamAccountName
        Name = $User.Name
        Department = $User.Department
        Title = $User.Title
        Enabled = $User.Enabled
        Description = $User.Description
        Groups = ($Groups | Sort-Object) -join "; "
    }
}

$Report | Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Access review report created: $ReportPath"
