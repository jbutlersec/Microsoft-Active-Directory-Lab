<# 
LA Lakers AD
Script: 03-create-users.ps1
Purpose: Creates AD users from CSV.

Expected CSV:
C:\LA Lakers AD\CSV\02-users.csv

Expected columns:
FirstName,LastName,SamAccountName,UserPrincipalName,Department,Title,OU,AccountType,Password
#>

Import-Module ActiveDirectory

$CsvPath = "C:\LA Lakers AD\CSV\02-users.csv"
$DomainDN = (Get-ADDomain).DistinguishedName
$DomainDnsRoot = (Get-ADDomain).DNSRoot

if (!(Test-Path $CsvPath)) {
    Write-Error "CSV file not found: $CsvPath"
    exit 1
}

$Users = Import-Csv $CsvPath

foreach ($User in $Users) {
    $FirstName = $User.FirstName.Trim()
    $LastName = $User.LastName.Trim()
    $Sam = $User.SamAccountName.Trim()
    $UPN = if ($User.UserPrincipalName) { $User.UserPrincipalName.Trim() } else { "$Sam@$DomainDnsRoot" }
    $Department = $User.Department
    $Title = $User.Title
    $OUName = $User.OU.Trim()
    $AccountType = $User.AccountType
    $PasswordPlain = if ($User.Password) { $User.Password } else { "P@ssw0rd123!" }
    $Password = ConvertTo-SecureString $PasswordPlain -AsPlainText -Force

    $TargetOU = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'" -SearchBase $DomainDN -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($null -eq $TargetOU) {
        Write-Warning "OU '$OUName' not found for user '$Sam'. Skipping."
        continue
    }

    $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Sam'" -ErrorAction SilentlyContinue

    if ($ExistingUser) {
        Write-Host "User already exists: $Sam"
    }
    else {
        New-ADUser `
            -GivenName $FirstName `
            -Surname $LastName `
            -Name "$FirstName $LastName" `
            -DisplayName "$FirstName $LastName" `
            -SamAccountName $Sam `
            -UserPrincipalName $UPN `
            -Department $Department `
            -Title $Title `
            -Path $TargetOU.DistinguishedName `
            -AccountPassword $Password `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -Description $AccountType

        Write-Host "Created user: $Sam"
    }
}
