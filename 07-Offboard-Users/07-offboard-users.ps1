<# 
LA Lakers AD
Script: 07-offboard-users.ps1
Purpose: Disables selected users, removes group memberships, and moves accounts to Offboarded OU.

Expected CSV:
C:\LA Lakers AD\CSV\07-offboard.csv

Expected columns:
SamAccountName,TicketNumber,Reason
#>

Import-Module ActiveDirectory

$CsvPath = "C:\LA Lakers AD\CSV\07-offboard.csv"
$DomainDN = (Get-ADDomain).DistinguishedName

if (!(Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

$OffboardedOU = Get-ADOrganizationalUnit -Filter "Name -eq 'Offboarded'" -SearchBase $DomainDN -ErrorAction SilentlyContinue | Select-Object -First 1

if ($null -eq $OffboardedOU) {
    Write-Error "Offboarded OU not found. Create it first using 01-create-ou-structure.ps1."
    exit 1
}

$UsersToOffboard = Import-Csv $CsvPath

foreach ($Entry in $UsersToOffboard) {
    $Sam = $Entry.SamAccountName.Trim()
    $Ticket = $Entry.TicketNumber
    $Reason = $Entry.Reason

    $User = Get-ADUser -Filter "SamAccountName -eq '$Sam'" -Properties MemberOf,Description -ErrorAction SilentlyContinue

    if ($null -eq $User) {
        Write-Warning "User not found: $Sam"
        continue
    }

    foreach ($GroupDN in $User.MemberOf) {
        try {
            Remove-ADGroupMember -Identity $GroupDN -Members $User -Confirm:$false
            Write-Host "Removed $Sam from $GroupDN"
        }
        catch {
            Write-Warning "Could not remove $Sam from $GroupDN"
        }
    }

    Disable-ADAccount -Identity $User
    Set-ADUser -Identity $User -Description "OFFBOARDED | Ticket: $Ticket | Reason: $Reason | Date: $(Get-Date -Format yyyy-MM-dd)"
    Move-ADObject -Identity $User.DistinguishedName -TargetPath $OffboardedOU.DistinguishedName

    Write-Host "Offboarded user: $Sam"
}
