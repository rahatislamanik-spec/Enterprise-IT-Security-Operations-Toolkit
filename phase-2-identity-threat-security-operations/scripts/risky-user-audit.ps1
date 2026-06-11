# Enterprise IT Security Operations Toolkit
# Phase 2 — Identity Threat & Security Operations
# Risky User Audit Report

Write-Host "===================================================="
Write-Host " PHASE 2 | RISKY USER AUDIT REPORT"
Write-Host "===================================================="

Connect-MgGraph -Scopes "IdentityRiskyUser.Read.All","Directory.Read.All","AuditLog.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting risky user data..." -ForegroundColor Yellow

try {
    $RiskyUsers = Get-MgRiskyUser -All

    $Results = foreach ($User in $RiskyUsers) {
        [PSCustomObject]@{
            UserPrincipalName = $User.UserPrincipalName
            RiskLevel         = $User.RiskLevel
            RiskState         = $User.RiskState
            RiskDetail        = $User.RiskDetail
            IsDeleted         = $User.IsDeleted
            IsProcessing      = $User.IsProcessing
        }
    }

    $CsvFile = "$ReportPath/Risky_User_Audit_Report_$DateStamp.csv"
    $Results | Export-Csv -Path $CsvFile -NoTypeInformation

    $HighRisk = ($Results | Where-Object { $_.RiskLevel -eq "high" }).Count
    $MediumRisk = ($Results | Where-Object { $_.RiskLevel -eq "medium" }).Count
    $LowRisk = ($Results | Where-Object { $_.RiskLevel -eq "low" }).Count

    Write-Host "`n====================================================" -ForegroundColor Green
    Write-Host " RISKY USER AUDIT COMPLETE" -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Green

    Write-Host "Total Risky Users: $($Results.Count)" -ForegroundColor Cyan
    Write-Host "High Risk Users: $HighRisk" -ForegroundColor Red
    Write-Host "Medium Risk Users: $MediumRisk" -ForegroundColor Yellow
    Write-Host "Low Risk Users: $LowRisk" -ForegroundColor Green
    Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green
}
catch {
    Write-Host "`nRisky User reporting may require Microsoft Entra ID P2 / Identity Protection permissions." -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}