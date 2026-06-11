# Enterprise IT Security Operations Toolkit
# Phase 2 — Identity Threat & Security Operations
# Secure Score Report

Write-Host "===================================================="
Write-Host " PHASE 2 | MICROSOFT SECURE SCORE REPORT"
Write-Host "===================================================="

Connect-MgGraph -Scopes "SecurityEvents.Read.All","SecurityActions.Read.All","Directory.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting Microsoft Secure Score data..." -ForegroundColor Yellow

try {
    $SecureScores = Get-MgSecuritySecureScore -Top 1

    $Results = foreach ($Score in $SecureScores) {
        [PSCustomObject]@{
            CreatedDateTime     = $Score.CreatedDateTime
            CurrentScore        = $Score.CurrentScore
            MaxScore            = $Score.MaxScore
            LicensedUserCount   = $Score.LicensedUserCount
            ActiveUserCount     = $Score.ActiveUserCount
            EnabledServices     = ($Score.EnabledServices -join "; ")
        }
    }

    $CsvFile = "$ReportPath/Secure_Score_Report_$DateStamp.csv"
    $Results | Export-Csv -Path $CsvFile -NoTypeInformation

    Write-Host "`n====================================================" -ForegroundColor Green
    Write-Host " SECURE SCORE REPORT COMPLETE" -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Green

    foreach ($Result in $Results) {
        Write-Host "Current Score: $($Result.CurrentScore)" -ForegroundColor Cyan
        Write-Host "Max Score: $($Result.MaxScore)" -ForegroundColor Cyan
        Write-Host "Licensed Users: $($Result.LicensedUserCount)" -ForegroundColor Yellow
        Write-Host "Active Users: $($Result.ActiveUserCount)" -ForegroundColor Yellow
    }

    Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green
}
catch {
    Write-Host "`nSecure Score reporting may require Microsoft security permissions/licensing." -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}