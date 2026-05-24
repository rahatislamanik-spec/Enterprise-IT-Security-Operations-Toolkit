# RahatOS Progress Center
# Inactive User Governance Report
# Tier 2/3 Identity Hygiene Audit

Write-Host "=========================================="
Write-Host " RAHATOS | INACTIVE USER GOVERNANCE AUDIT "
Write-Host "=========================================="

Connect-MgGraph -Scopes "User.Read.All","AuditLog.Read.All","Directory.Read.All"

$ReportPath = "$HOME/Documents/RahatOS-Progress-Center/reports/m365"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$CutoffDate = (Get-Date).AddDays(-30)

Write-Host "`nCollecting inactive user data..." -ForegroundColor Yellow

$Users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,UserType,CreatedDateTime,SignInActivity,AssignedLicenses,Department,JobTitle

$Results = foreach ($User in $Users) {

    $LastSignIn = $User.SignInActivity.LastSignInDateTime
    $LicenseCount = $User.AssignedLicenses.Count

    $RiskFlag = if ($User.AccountEnabled -eq $true -and -not $LastSignIn) {
        "Review - Enabled User With No Sign-In Data"
    } elseif ($User.AccountEnabled -eq $true -and $LastSignIn -lt $CutoffDate -and $LicenseCount -gt 0) {
        "Review - Licensed Inactive User"
    } elseif ($User.AccountEnabled -eq $true -and $LastSignIn -lt $CutoffDate) {
        "Review - Inactive Enabled User"
    } elseif ($User.AccountEnabled -eq $false -and $LicenseCount -gt 0) {
        "Review - Disabled User Still Licensed"
    } else {
        "OK"
    }

    [PSCustomObject]@{
        DisplayName       = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        AccountEnabled    = $User.AccountEnabled
        UserType          = $User.UserType
        Department        = $User.Department
        JobTitle          = $User.JobTitle
        LastSignIn        = $LastSignIn
        LicenseCount      = $LicenseCount
        RiskFlag          = $RiskFlag
    }
}

$CsvFile = "$ReportPath/Inactive_User_Governance_Report_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$ReviewItems = ($Results | Where-Object {$_.RiskFlag -ne "OK"}).Count
$LicensedInactive = ($Results | Where-Object {$_.RiskFlag -eq "Review - Licensed Inactive User"}).Count
$DisabledLicensed = ($Results | Where-Object {$_.RiskFlag -eq "Review - Disabled User Still Licensed"}).Count

Write-Host "`n=========================================="
Write-Host " INACTIVE USER GOVERNANCE AUDIT COMPLETE "
Write-Host "=========================================="

Write-Host "Total Users Reviewed: $($Results.Count)" -ForegroundColor Cyan
Write-Host "Total Review Items: $ReviewItems" -ForegroundColor Yellow
Write-Host "Licensed Inactive Users: $LicensedInactive" -ForegroundColor Yellow
Write-Host "Disabled Users Still Licensed: $DisabledLicensed" -ForegroundColor Red
Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green