# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: License Utilization & Optimization Report
# Author: Md Rahat Islam Anik
# Description: Pulls tenant-wide license allocation data via Microsoft Graph,
#   identifies waste (disabled users holding licenses, unlicensed active users),
#   and exports a cost-optimization report.

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | LICENSE REPORT       " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "User.Read.All","Directory.Read.All","Organization.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting SKU / subscription data..." -ForegroundColor Yellow

# Tenant-level SKU summary
$Skus = Get-MgSubscribedSku
$SkuSummary = foreach ($Sku in $Skus) {
    [PSCustomObject]@{
        SkuName       = $Sku.SkuPartNumber
        Purchased     = $Sku.PrepaidUnits.Enabled
        Assigned      = $Sku.ConsumedUnits
        Available     = ($Sku.PrepaidUnits.Enabled - $Sku.ConsumedUnits)
        UtilizationPct = if ($Sku.PrepaidUnits.Enabled -gt 0) {
                            [math]::Round(($Sku.ConsumedUnits / $Sku.PrepaidUnits.Enabled) * 100, 1)
                         } else { 0 }
    }
}

# Per-user license mapping
Write-Host "Collecting user license assignments..." -ForegroundColor Yellow
$Users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,UserType,AssignedLicenses,Department,JobTitle

$UserReport = foreach ($User in $Users) {
    $LicenseCount = $User.AssignedLicenses.Count
    $OptFlag = if ($User.AccountEnabled -eq $false -and $LicenseCount -gt 0) {
        "WASTE — Disabled User With License"
    } elseif ($User.AccountEnabled -eq $true -and $LicenseCount -eq 0 -and $User.UserType -eq "Member") {
        "REVIEW — Active Member Without License"
    } else { "OK" }

    [PSCustomObject]@{
        DisplayName       = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        AccountEnabled    = $User.AccountEnabled
        UserType          = $User.UserType
        Department        = $User.Department
        JobTitle          = $User.JobTitle
        LicenseCount      = $LicenseCount
        OptimizationFlag  = $OptFlag
    }
}

# Export both reports
$SkuCsv  = "$ReportPath/License_SKU_Summary_$DateStamp.csv"
$UserCsv = "$ReportPath/License_User_Report_$DateStamp.csv"
$SkuSummary  | Export-Csv -Path $SkuCsv  -NoTypeInformation
$UserReport  | Export-Csv -Path $UserCsv -NoTypeInformation

$WastedLicenses = ($UserReport | Where-Object { $_.OptimizationFlag -like "WASTE*" }).Count
$ReviewItems    = ($UserReport | Where-Object { $_.OptimizationFlag -like "REVIEW*" }).Count

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " LICENSE REPORT COMPLETE                        " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
$SkuSummary | Format-Table SkuName, Purchased, Assigned, Available, UtilizationPct -AutoSize
Write-Host "License Waste Items    : $WastedLicenses" -ForegroundColor Red
Write-Host "Review Items           : $ReviewItems"    -ForegroundColor Yellow
Write-Host "`nSKU CSV   : $SkuCsv"  -ForegroundColor Green
Write-Host "User CSV  : $UserCsv"  -ForegroundColor Green
