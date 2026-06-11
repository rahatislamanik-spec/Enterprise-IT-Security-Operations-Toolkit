# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: PIM Role Activation Audit
# Author: Md Rahat Islam Anik
# Description: Queries the Entra ID audit log for Privileged Identity Management
#   (PIM) role activation events within a configurable lookback window.
#   Surfaces who activated which role, when, and from where — key evidence
#   for privileged access governance and SOC investigations.

param (
    [int]$LookbackDays = 7
)

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | PIM ACTIVATION AUDIT " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "AuditLog.Read.All","Directory.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp  = Get-Date -Format "yyyy-MM-dd_HH-mm"
$StartDate  = (Get-Date).AddDays(-$LookbackDays).ToString("yyyy-MM-ddTHH:mm:ssZ")

Write-Host "`nLookback window: Last $LookbackDays days (from $StartDate)" -ForegroundColor Yellow
Write-Host "Querying PIM activation events in audit log..." -ForegroundColor Yellow

try {
    $AuditLogs = Get-MgAuditLogDirectoryAudit -All -Filter "activityDisplayName eq 'Add member to role completed (PIM activation)' and activityDateTime ge $StartDate"

    $Results = foreach ($Log in $AuditLogs) {
        $Initiator = $Log.InitiatedBy.User
        $TargetRole = ($Log.TargetResources | Where-Object { $_.Type -eq "Role" } | Select-Object -First 1).DisplayName
        $TargetUser = ($Log.TargetResources | Where-Object { $_.Type -eq "User" } | Select-Object -First 1).UserPrincipalName

        [PSCustomObject]@{
            ActivationTime    = $Log.ActivityDateTime
            InitiatedBy       = $Initiator.UserPrincipalName
            ActivatedRole     = $TargetRole
            ActivatedFor      = $TargetUser
            Result            = $Log.Result
            IPAddress         = $Initiator.IPAddress
            CorrelationId     = $Log.CorrelationId
        }
    }

    $CsvFile = "$ReportPath/PIM_Activation_Audit_${LookbackDays}days_$DateStamp.csv"
    $Results | Export-Csv -Path $CsvFile -NoTypeInformation

    Write-Host "`n=================================================" -ForegroundColor Green
    Write-Host " PIM ACTIVATION AUDIT COMPLETE                  " -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Green
    Write-Host "Total PIM Activations  : $($Results.Count)"  -ForegroundColor Cyan
    if ($Results.Count -gt 0) {
        $Results | Group-Object ActivatedRole | Sort-Object Count -Descending | ForEach-Object {
            Write-Host "  $($_.Name): $($_.Count) activation(s)" -ForegroundColor Yellow
        }
    }
    Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green

} catch {
    Write-Host "`nPIM audit may require Entra ID P2 licensing or elevated permissions." -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
