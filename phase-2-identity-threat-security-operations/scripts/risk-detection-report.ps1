# Enterprise IT Security Operations Toolkit
# Phase 2 — Identity Threat & Security Operations
# Risk Detection Report

Write-Host "===================================================="
Write-Host " PHASE 2 | RISK DETECTION REPORT"
Write-Host "===================================================="

Connect-MgGraph -Scopes "IdentityRiskEvent.Read.All","AuditLog.Read.All","Directory.Read.All"

$ReportPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-2-identity-threat-security-operations/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting identity risk detections..." -ForegroundColor Yellow

try {

    $Detections = Get-MgRiskDetection -All

    $Results = foreach ($Detection in $Detections) {

        [PSCustomObject]@{
            UserPrincipalName = $Detection.UserPrincipalName
            RiskType          = $Detection.RiskEventType
            RiskLevel         = $Detection.RiskLevel
            RiskState         = $Detection.RiskState
            Source            = $Detection.Source
            DetectedDateTime  = $Detection.DetectedDateTime
            Activity          = $Detection.Activity
            IPAddress         = $Detection.IpAddress
            Location          = $Detection.Location
        }
    }

    $CsvFile = "$ReportPath/Risk_Detection_Report_$DateStamp.csv"

    $Results | Export-Csv -Path $CsvFile -NoTypeInformation

    Write-Host "`n====================================================" -ForegroundColor Green
    Write-Host " RISK DETECTION REPORT COMPLETE" -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Green

    Write-Host "Total Risk Detections: $($Results.Count)" -ForegroundColor Cyan

    $Results | Group-Object RiskType | ForEach-Object {
        Write-Host "$($_.Name): $($_.Count)" -ForegroundColor Yellow
    }

    Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green
}
catch {

    Write-Host "`nIdentity Protection reporting may require Microsoft Entra ID P2 licensing." -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}