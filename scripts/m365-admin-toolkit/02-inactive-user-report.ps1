# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: Inactive User Governance Report
# Author: Md Rahat Islam Anik
# Description: Identifies users with no sign-in activity within a configurable
#   threshold and flags them for review — including licensed-but-inactive accounts
#   and enabled accounts with no sign-in history at all.

param (
    [int]$InactiveDaysThreshold = 30
)

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | INACTIVE USER REPORT " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "User.Read.All","AuditLog.Read.All","Directory.Read.All"

$ReportPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp  = Get-Date -Format "yyyy-MM-dd_HH-mm"
$CutoffDate = (Get-Date).AddDays(-$InactiveDaysThreshold)

Write-Host "`nThreshold: $InactiveDaysThreshold days (cutoff: $($CutoffDate.ToString('yyyy-MM-dd')))" -ForegroundColor Yellow
Write-Host "Collecting user data..." -ForegroundColor Yellow

$Users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,UserType,AssignedLicenses,SignInActivity,Department,JobTitle,CreatedDateTime

$Results = foreach ($User in $Users) {
    $LastSignIn  = $User.SignInActivity.LastSignInDateTime
    $LicenseCount = $User.AssignedLicenses.Count

    $StatusFlag = if (-not $LastSignIn -and $User.AccountEnabled) {
        "REVIEW — Enabled, No Sign-In History"
    } elseif ($LastSignIn -lt $CutoffDate -and $User.AccountEnabled -and $LicenseCount -gt 0) {
        "REVIEW — Licensed Inactive User"
    } elseif ($LastSignIn -lt $CutoffDate -and $User.AccountEnabled) {
        "REVIEW — Inactive Enabled User"
    } elseif (-not $User.AccountEnabled -and $LicenseCount -gt 0) {
        "REVIEW — Disabled User Retaining License"
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
        StatusFlag        = $StatusFlag
        CreatedDateTime   = $User.CreatedDateTime
    }
}

$CsvFile = "$ReportPath/Inactive_User_Report_${InactiveDaysThreshold}days_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$ReviewCount    = ($Results | Where-Object { $_.StatusFlag -ne "OK" }).Count
$LicWaste       = ($Results | Where-Object { $_.StatusFlag -like "*Licensed Inactive*" }).Count
$DisabledLic    = ($Results | Where-Object { $_.StatusFlag -like "*Disabled*" }).Count

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " INACTIVE USER REPORT COMPLETE                  " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host "Total Users Evaluated : $($Results.Count)"  -ForegroundColor Cyan
Write-Host "Accounts Flagged       : $ReviewCount"       -ForegroundColor Yellow
Write-Host "Licensed Inactive      : $LicWaste"          -ForegroundColor Red
Write-Host "Disabled + Licensed    : $DisabledLic"       -ForegroundColor Red
Write-Host "`nCSV Exported: $CsvFile"                    -ForegroundColor Green
