# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: Administrative Role Review
# Author: Md Rahat Islam Anik
# Description: Enumerates all active Entra ID directory role assignments,
#   classifies them by risk tier (Critical / High / Medium / Standard),
#   flags disabled accounts retaining privileged roles, and exports a
#   governance evidence report for access reviews.

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | ADMIN ROLE REVIEW    " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "RoleManagement.Read.Directory","Directory.Read.All","User.Read.All"

$ReportPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

$RiskMap = @{
    "Global Administrator"            = "CRITICAL"
    "Privileged Role Administrator"   = "CRITICAL"
    "Security Administrator"          = "HIGH"
    "Exchange Administrator"          = "HIGH"
    "Intune Administrator"            = "HIGH"
    "Conditional Access Administrator" = "HIGH"
    "SharePoint Administrator"        = "MEDIUM"
    "Teams Administrator"             = "MEDIUM"
    "User Administrator"              = "MEDIUM"
    "Helpdesk Administrator"          = "STANDARD"
    "Reports Reader"                  = "STANDARD"
}

Write-Host "`nEnumerating directory roles..." -ForegroundColor Yellow
$Roles   = Get-MgDirectoryRole
$Results = [System.Collections.Generic.List[object]]::new()

foreach ($Role in $Roles) {
    $Members = Get-MgDirectoryRoleMember -DirectoryRoleId $Role.Id
    foreach ($Member in $Members) {
        try {
            $User = Get-MgUser -UserId $Member.Id -Property DisplayName,UserPrincipalName,AccountEnabled,Department,JobTitle -ErrorAction Stop
            $Risk = if ($RiskMap.ContainsKey($Role.DisplayName)) { $RiskMap[$Role.DisplayName] } else { "STANDARD" }
            $Flag = if (-not $User.AccountEnabled -and $Risk -in @("CRITICAL","HIGH")) {
                "ALERT — Disabled Account Holds $Risk Role"
            } elseif (-not $User.AccountEnabled) {
                "REVIEW — Disabled Account Has Role Assignment"
            } else { "OK" }

            $Results.Add([PSCustomObject]@{
                RoleName          = $Role.DisplayName
                RiskTier          = $Risk
                DisplayName       = $User.DisplayName
                UserPrincipalName = $User.UserPrincipalName
                Department        = $User.Department
                JobTitle          = $User.JobTitle
                AccountEnabled    = $User.AccountEnabled
                GovernanceFlag    = $Flag
            })
        } catch { continue }
    }
}

$CsvFile = "$ReportPath/Admin_Role_Review_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$Critical = ($Results | Where-Object { $_.RiskTier -eq "CRITICAL" }).Count
$High     = ($Results | Where-Object { $_.RiskTier -eq "HIGH" }).Count
$Alerts   = ($Results | Where-Object { $_.GovernanceFlag -ne "OK" }).Count

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " ADMIN ROLE REVIEW COMPLETE                     " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host "Total Role Assignments : $($Results.Count)"   -ForegroundColor Cyan
Write-Host "Critical Role Holders  : $Critical"           -ForegroundColor Red
Write-Host "High Risk Role Holders : $High"               -ForegroundColor Yellow
Write-Host "Governance Alerts      : $Alerts"             -ForegroundColor Red
Write-Host "`nCSV Exported: $CsvFile"                     -ForegroundColor Green
