# Enterprise IT Security Operations Toolkit
# Microsoft 365 License Optimization Report
# Author: Md Rahat Islam Anik

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | LICENSE OPTIMIZATION REPORT " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "User.Read.All","Directory.Read.All","Organization.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting license data..." -ForegroundColor Yellow

$Users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,UserType,AssignedLicenses,CreatedDateTime,Department,JobTitle

$Results = foreach ($User in $Users) {

    $LicenseCount = $User.AssignedLicenses.Count

    $LicenseStatus = if ($LicenseCount -gt 0) {
        "Licensed"
    } else {
        "Unlicensed"
    }

    $OptimizationFlag = if ($User.AccountEnabled -eq $false -and $LicenseCount -gt 0) {
        "Review - Disabled User Has License"
    } elseif ($User.AccountEnabled -eq $true -and $LicenseCount -eq 0) {
        "Review - Active User Without License"
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
        LicenseCount      = $LicenseCount
        LicenseStatus     = $LicenseStatus
        OptimizationFlag  = $OptimizationFlag
    }
}

$CsvFile = "$ReportPath/License_Optimization_Report_$DateStamp.csv"

$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$TotalUsers = $Results.Count
$LicensedUsers = ($Results | Where-Object {$_.LicenseStatus -eq "Licensed"}).Count
$UnlicensedUsers = ($Results | Where-Object {$_.LicenseStatus -eq "Unlicensed"}).Count
$DisabledLicensedUsers = ($Results | Where-Object {$_.OptimizationFlag -eq "Review - Disabled User Has License"}).Count
$ActiveUnlicensedUsers = ($Results | Where-Object {$_.OptimizationFlag -eq "Review - Active User Without License"}).Count

Write-Host "`n=======================================" -ForegroundColor Green
Write-Host " LICENSE OPTIMIZATION REPORT COMPLETE " -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

Write-Host "Total Users: $TotalUsers" -ForegroundColor Cyan
Write-Host "Licensed Users: $LicensedUsers" -ForegroundColor Cyan
Write-Host "Unlicensed Users: $UnlicensedUsers" -ForegroundColor Yellow
Write-Host "Disabled Users With Licenses: $DisabledLicensedUsers" -ForegroundColor Red
Write-Host "Active Users Without Licenses: $ActiveUnlicensedUsers" -ForegroundColor Yellow

Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green