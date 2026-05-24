# RahatOS Progress Center
# Microsoft 365 Tenant Health Report
# Report: Tenant Health Summary
# Author: Md Rahat Islam Anik

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host " RAHATOS | MICROSOFT 365 TENANT HEALTH REPORT " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All","Directory.Read.All","Organization.Read.All"

# Create report folder
$ReportPath = "$HOME/Documents/RahatOS-Progress-Center/reports/m365"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

# Date stamp
$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting tenant data..." -ForegroundColor Yellow

# Organization info
$Org = Get-MgOrganization | Select-Object DisplayName, Id, CountryLetterCode, VerifiedDomains

# Users
$Users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,UserType,AssignedLicenses,CreatedDateTime

$TotalUsers = $Users.Count
$EnabledUsers = ($Users | Where-Object {$_.AccountEnabled -eq $true}).Count
$DisabledUsers = ($Users | Where-Object {$_.AccountEnabled -eq $false}).Count
$GuestUsers = ($Users | Where-Object {$_.UserType -eq "Guest"}).Count
$LicensedUsers = ($Users | Where-Object {$_.AssignedLicenses.Count -gt 0}).Count
$UnlicensedUsers = ($Users | Where-Object {$_.AssignedLicenses.Count -eq 0}).Count

# Groups
$Groups = Get-MgGroup -All -Property DisplayName,GroupTypes,SecurityEnabled,MailEnabled

$TotalGroups = $Groups.Count
$SecurityGroups = ($Groups | Where-Object {$_.SecurityEnabled -eq $true}).Count
$MailEnabledGroups = ($Groups | Where-Object {$_.MailEnabled -eq $true}).Count
$DynamicGroups = ($Groups | Where-Object {$_.GroupTypes -contains "DynamicMembership"}).Count

# Directory roles
$Roles = Get-MgDirectoryRole
$TotalActiveRoles = $Roles.Count

# Build report object
$Report = [PSCustomObject]@{
    ReportName          = "Microsoft 365 Tenant Health Report"
    GeneratedOn         = Get-Date
    TenantName          = $Org.DisplayName
    TenantId            = $Org.Id
    Country             = $Org.CountryLetterCode
    TotalUsers          = $TotalUsers
    EnabledUsers        = $EnabledUsers
    DisabledUsers       = $DisabledUsers
    GuestUsers          = $GuestUsers
    LicensedUsers       = $LicensedUsers
    UnlicensedUsers     = $UnlicensedUsers
    TotalGroups         = $TotalGroups
    SecurityGroups      = $SecurityGroups
    MailEnabledGroups   = $MailEnabledGroups
    DynamicGroups       = $DynamicGroups
    ActiveDirectoryRoles = $TotalActiveRoles
}

# Export CSV
$CsvFile = "$ReportPath/TenantHealthReport_$DateStamp.csv"
$Report | Export-Csv -Path $CsvFile -NoTypeInformation

# Export readable text report
$TxtFile = "$ReportPath/TenantHealthReport_$DateStamp.txt"

@"
===============================================
RAHATOS | MICROSOFT 365 TENANT HEALTH REPORT
===============================================

Generated On: $($Report.GeneratedOn)

Tenant Name: $($Report.TenantName)
Tenant ID: $($Report.TenantId)
Country: $($Report.Country)

USER SUMMARY
-----------------------------------------------
Total Users: $TotalUsers
Enabled Users: $EnabledUsers
Disabled Users: $DisabledUsers
Guest Users: $GuestUsers
Licensed Users: $LicensedUsers
Unlicensed Users: $UnlicensedUsers

GROUP SUMMARY
-----------------------------------------------
Total Groups: $TotalGroups
Security Groups: $SecurityGroups
Mail Enabled Groups: $MailEnabledGroups
Dynamic Groups: $DynamicGroups

ADMIN / ROLE SUMMARY
-----------------------------------------------
Active Directory Roles: $TotalActiveRoles

REPORT FILES
-----------------------------------------------
CSV: $CsvFile
TXT: $TxtFile

===============================================
Report completed successfully.
===============================================
"@ | Out-File -FilePath $TxtFile

Write-Host "`nTenant Health Report Complete!" -ForegroundColor Green
Write-Host "CSV Exported: $CsvFile" -ForegroundColor Cyan
Write-Host "TXT Exported: $TxtFile" -ForegroundColor Cyan