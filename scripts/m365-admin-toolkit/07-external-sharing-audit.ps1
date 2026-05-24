# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: External Sharing & Guest Access Audit
# Author: Md Rahat Islam Anik
# Description: Audits external sharing exposure in the M365 tenant —
#   inventories all guest users, flags accounts with no recent sign-in,
#   identifies domains invited, and surfaces governance risks from
#   unreviewed external access.

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | EXTERNAL SHARING AUDIT" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "User.Read.All","Directory.Read.All","AuditLog.Read.All"

$ReportPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp      = Get-Date -Format "yyyy-MM-dd_HH-mm"
$InactiveWindow = (Get-Date).AddDays(-90)

Write-Host "`nCollecting guest user data..." -ForegroundColor Yellow

$Guests = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,UserType,CreatedDateTime,SignInActivity,Mail |
          Where-Object { $_.UserType -eq "Guest" }

$Results = foreach ($Guest in $Guests) {
    $LastSignIn   = $Guest.SignInActivity.LastSignInDateTime
    $ExternalDomain = if ($Guest.Mail) { ($Guest.Mail -split "@")[1] } else { "Unknown" }

    $RiskFlag = if (-not $Guest.AccountEnabled) {
        "REVIEW — Disabled Guest Account"
    } elseif (-not $LastSignIn) {
        "REVIEW — Guest with No Sign-In History"
    } elseif ($LastSignIn -lt $InactiveWindow) {
        "REVIEW — Guest Inactive > 90 Days"
    } else {
        "OK — Active Guest"
    }

    [PSCustomObject]@{
        DisplayName     = $Guest.DisplayName
        GuestUPN        = $Guest.UserPrincipalName
        ExternalDomain  = $ExternalDomain
        AccountEnabled  = $Guest.AccountEnabled
        InvitedOn       = $Guest.CreatedDateTime
        LastSignIn      = $LastSignIn
        DaysSinceSignIn = if ($LastSignIn) { [math]::Round(((Get-Date) - $LastSignIn).TotalDays, 0) } else { "Never" }
        GovernanceFlag  = $RiskFlag
    }
}

$CsvFile = "$ReportPath/External_Sharing_Audit_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$TotalGuests   = $Results.Count
$ReviewItems   = ($Results | Where-Object { $_.GovernanceFlag -ne "OK — Active Guest" }).Count
$NeverSignedIn = ($Results | Where-Object { $_.DaysSinceSignIn -eq "Never" }).Count
$UniqueDomains = ($Results | Select-Object -ExpandProperty ExternalDomain | Sort-Object -Unique).Count

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " EXTERNAL SHARING AUDIT COMPLETE                " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host "Total Guest Accounts   : $TotalGuests"    -ForegroundColor Cyan
Write-Host "External Domains       : $UniqueDomains"  -ForegroundColor Cyan
Write-Host "Governance Review Items: $ReviewItems"    -ForegroundColor Yellow
Write-Host "Never Signed In        : $NeverSignedIn"  -ForegroundColor Red
Write-Host "`nCSV Exported: $CsvFile"                 -ForegroundColor Green
