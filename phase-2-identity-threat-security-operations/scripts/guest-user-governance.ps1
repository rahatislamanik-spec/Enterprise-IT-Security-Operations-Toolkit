# Enterprise IT Security Operations Toolkit
# Phase 2 — Identity Threat & Security Operations
# Guest User Governance Report

Write-Host "===================================================="
Write-Host " PHASE 2 | GUEST USER GOVERNANCE REPORT"
Write-Host "===================================================="

Connect-MgGraph -Scopes "User.Read.All","Directory.Read.All","AuditLog.Read.All"

$ReportPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-2-identity-threat-security-operations/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting guest user data..." -ForegroundColor Yellow

$Guests = Get-MgUser -All -Property DisplayName,UserPrincipalName,UserType,AccountEnabled,CreatedDateTime,SignInActivity |
Where-Object { $_.UserType -eq "Guest" }

$Results = foreach ($Guest in $Guests) {
    [PSCustomObject]@{
        DisplayName       = $Guest.DisplayName
        UserPrincipalName = $Guest.UserPrincipalName
        UserType          = $Guest.UserType
        AccountEnabled    = $Guest.AccountEnabled
        CreatedDateTime   = $Guest.CreatedDateTime
        LastSignIn        = $Guest.SignInActivity.LastSignInDateTime
    }
}

$CsvFile = "$ReportPath/Guest_User_Governance_Report_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

Write-Host "`n====================================================" -ForegroundColor Green
Write-Host " GUEST USER GOVERNANCE REPORT COMPLETE" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green

Write-Host "Total Guest Users: $($Results.Count)" -ForegroundColor Cyan
Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green