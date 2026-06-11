# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Conditional Access Audit Report
# Author: Md Rahat Islam Anik

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | CONDITIONAL ACCESS AUDIT " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "Policy.Read.All","Directory.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting Conditional Access policies..." -ForegroundColor Yellow

$Policies = Get-MgIdentityConditionalAccessPolicy

$Results = foreach ($Policy in $Policies) {

    [PSCustomObject]@{
        PolicyName = $Policy.DisplayName
        State = $Policy.State
        CreatedDate = $Policy.CreatedDateTime
        ModifiedDate = $Policy.ModifiedDateTime
    }
}

$CsvFile = "$ReportPath/Conditional_Access_Audit_$DateStamp.csv"

$Results | Export-Csv -Path $CsvFile -NoTypeInformation

Write-Host "`n=======================================" -ForegroundColor Green
Write-Host " CONDITIONAL ACCESS AUDIT COMPLETE " -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

Write-Host "Policies Found: $($Results.Count)" -ForegroundColor Cyan
Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green