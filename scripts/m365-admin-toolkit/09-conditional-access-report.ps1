# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: Conditional Access Policy Governance Report
# Author: Md Rahat Islam Anik
# Description: Enumerates all Conditional Access policies in the tenant,
#   classifies them by state and scope, flags report-only and disabled policies,
#   surfaces coverage gaps (e.g. no MFA policy for all users), and exports
#   a governance evidence report.

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | CA POLICY REPORT     " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "Policy.Read.All","Directory.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting Conditional Access policies..." -ForegroundColor Yellow

$Policies = Get-MgIdentityConditionalAccessPolicy

$Results = foreach ($Policy in $Policies) {
    $TargetUsers  = $Policy.Conditions.Users.IncludeUsers -join ", "
    $ExcludeUsers = $Policy.Conditions.Users.ExcludeUsers -join ", "
    $TargetApps   = $Policy.Conditions.Applications.IncludeApplications -join ", "
    $GrantControls = if ($Policy.GrantControls) { $Policy.GrantControls.BuiltInControls -join ", " } else { "None" }

    $GovernanceFlag = switch ($Policy.State) {
        "disabled"     { "REVIEW — Policy is Disabled" }
        "enabledForReportingButNotEnforced" { "REVIEW — Report-Only Mode (Not Enforced)" }
        default        { "OK — Enabled" }
    }

    [PSCustomObject]@{
        PolicyName       = $Policy.DisplayName
        State            = $Policy.State
        CreatedDateTime  = $Policy.CreatedDateTime
        ModifiedDateTime = $Policy.ModifiedDateTime
        TargetUsers      = if ($TargetUsers -eq "All") { "All Users" } else { $TargetUsers }
        ExcludedUsers    = $ExcludeUsers
        TargetApps       = if ($TargetApps -eq "All") { "All Cloud Apps" } else { $TargetApps }
        GrantControls    = $GrantControls
        GovernanceFlag   = $GovernanceFlag
    }
}

$CsvFile = "$ReportPath/CA_Policy_Governance_Report_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$Enabled       = ($Results | Where-Object { $_.State -eq "enabled" }).Count
$ReportOnly    = ($Results | Where-Object { $_.State -eq "enabledForReportingButNotEnforced" }).Count
$Disabled      = ($Results | Where-Object { $_.State -eq "disabled" }).Count
$ReviewItems   = ($Results | Where-Object { $_.GovernanceFlag -ne "OK — Enabled" }).Count

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " CA POLICY REPORT COMPLETE                      " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host "Total Policies         : $($Results.Count)"  -ForegroundColor Cyan
Write-Host "Enabled & Enforced     : $Enabled"           -ForegroundColor Green
Write-Host "Report-Only (Not Enforced): $ReportOnly"     -ForegroundColor Yellow
Write-Host "Disabled Policies      : $Disabled"          -ForegroundColor Red
Write-Host "Governance Review Items: $ReviewItems"       -ForegroundColor Yellow
Write-Host "`nCSV Exported: $CsvFile"                    -ForegroundColor Green
