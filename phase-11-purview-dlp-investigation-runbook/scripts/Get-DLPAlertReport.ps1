# =============================================================
#  Get-DLPAlertReport.ps1
#  Phase 11 — Microsoft Purview DLP Investigation Runbook
#  Enterprise-IT-Security-Operations-Toolkit
#  Author: Md Rahat Islam Anik
#  Scenario: Crestline Retail Group — fictional 300-user, 6-site environment
#  Environment: Microsoft 365 E5
#  Regulatory Framework: PIPEDA, Canadian PII Compliance
#
#  Description:
#  Connects to Security and Compliance PowerShell and exports
#  DLP policy alert data for a specified date range. Supports
#  filtering by policy name and severity. Results are exported
#  to a timestamped CSV report for investigation documentation.
#
#  Prerequisites:
#  - Exchange Online Management module installed
#    Install-Module ExchangeOnlineManagement -Scope CurrentUser
#  - Permissions: Compliance Administrator or Security Administrator
#    role in Microsoft Purview compliance portal
#  - PowerShell 7 recommended
#
#  Usage:
#  .\Get-DLPAlertReport.ps1
#  .\Get-DLPAlertReport.ps1 -PolicyName "CrestlineRetailGroup-PIPEDA-Core"
#  .\Get-DLPAlertReport.ps1 -Severity High -StartDate "2026-01-01"
#  .\Get-DLPAlertReport.ps1 -PolicyName "CrestlineRetailGroup-HR-Records-Protection" -Severity Medium -StartDate "2026-05-01" -EndDate "2026-06-01"
# =============================================================

#region Parameters
[CmdletBinding()]
param (
    # PolicyName: Filter results to alerts from a specific DLP policy.
    # If omitted, alerts from all policies are returned.
    [Parameter(Mandatory = $false)]
    [string]$PolicyName = "",

    # Severity: Filter by alert severity level.
    # Valid values: High, Medium, Low. If omitted, all severities are returned.
    [Parameter(Mandatory = $false)]
    [ValidateSet("High", "Medium", "Low", "")]
    [string]$Severity = "",

    # StartDate: Beginning of the date range for alert retrieval.
    # Defaults to 30 days ago if not specified.
    [Parameter(Mandatory = $false)]
    [datetime]$StartDate = (Get-Date).AddDays(-30),

    # EndDate: End of the date range for alert retrieval.
    # Defaults to the current date and time if not specified.
    [Parameter(Mandatory = $false)]
    [datetime]$EndDate = (Get-Date),

    # OutputPath: Directory where the CSV report will be saved.
    # Defaults to ~/Documents/Enterprise-IT-Security-Operations-Toolkit/
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-11-purview-dlp-investigation-runbook/reports"
)
#endregion

#region Initialization
$DateStamp = Get-Date -Format "yyyy-MM-dd_HHmm"

Write-Host ""
Write-Host "=============================================================" -ForegroundColor DarkGray
Write-Host "  Get-DLPAlertReport.ps1" -ForegroundColor Cyan
Write-Host "  Phase 11 — Microsoft Purview DLP Investigation Runbook" -ForegroundColor Cyan
Write-Host "  Crestline Retail Group — Microsoft 365 E5 Environment" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Date Range : $($StartDate.ToString('yyyy-MM-dd')) to $($EndDate.ToString('yyyy-MM-dd'))" -ForegroundColor White
if ($PolicyName) {
    Write-Host "  Policy     : $PolicyName" -ForegroundColor White
} else {
    Write-Host "  Policy     : All policies" -ForegroundColor White
}
if ($Severity) {
    Write-Host "  Severity   : $Severity" -ForegroundColor White
} else {
    Write-Host "  Severity   : All severities" -ForegroundColor White
}
Write-Host "  Output     : $OutputPath" -ForegroundColor White
Write-Host ""
#endregion

#region Output Directory
# Create the output directory if it does not already exist.
if (-not (Test-Path -Path $OutputPath)) {
    try {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        Write-Host "  [+] Output directory created: $OutputPath" -ForegroundColor Green
    } catch {
        Write-Host "  [!] Failed to create output directory: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}
#endregion

#region Connect to Security and Compliance PowerShell
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 1 — Connecting to Security and Compliance PowerShell" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

try {
    # Connect-IPPSSession establishes the Security and Compliance PowerShell session.
    # This is the correct connection method for Microsoft Purview compliance cmdlets.
    Connect-IPPSSession -ShowBanner:$false
    Write-Host "  [+] Connected to Security and Compliance PowerShell" -ForegroundColor Green
} catch {
    Write-Host "  [!] Failed to connect: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  [i] Ensure ExchangeOnlineManagement module is installed:" -ForegroundColor Yellow
    Write-Host "      Install-Module ExchangeOnlineManagement -Scope CurrentUser" -ForegroundColor Yellow
    exit 1
}
Write-Host ""
#endregion

#region Retrieve DLP Alerts
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 2 — Retrieving DLP Alert Data" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Querying Purview compliance portal for DLP alerts..." -ForegroundColor White

try {
    # Get-ProtectionAlert retrieves DLP alerts from the Purview compliance portal.
    # Each alert corresponds to a user action that matched a DLP policy rule.
    $AllAlerts = Get-ProtectionAlert -StartTimeUtc $StartDate.ToUniversalTime() -EndTimeUtc $EndDate.ToUniversalTime()

    if ($null -eq $AllAlerts -or $AllAlerts.Count -eq 0) {
        Write-Host "  [!] No DLP alerts found for the specified date range." -ForegroundColor Yellow
        Write-Host "      Date range: $($StartDate.ToString('yyyy-MM-dd')) to $($EndDate.ToString('yyyy-MM-dd'))" -ForegroundColor Yellow
        Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue
        exit 0
    }

    Write-Host "  [+] Total alerts retrieved from Purview: $($AllAlerts.Count)" -ForegroundColor Green

} catch {
    Write-Host "  [!] Failed to retrieve DLP alerts: $($_.Exception.Message)" -ForegroundColor Red
    Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue
    exit 1
}
#endregion

#region Filter Alerts
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 3 — Applying Filters" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

$FilteredAlerts = $AllAlerts

# Filter by policy name if specified.
# Partial matching is used so that a policy display name substring can be passed.
if ($PolicyName) {
    $FilteredAlerts = $FilteredAlerts | Where-Object { $_.Name -like "*$PolicyName*" }
    Write-Host "  [+] After policy name filter ('$PolicyName'): $($FilteredAlerts.Count) alerts" -ForegroundColor White
}

# Filter by severity level if specified.
# Severity values in Purview: High, Medium, Low (case-insensitive).
if ($Severity) {
    $FilteredAlerts = $FilteredAlerts | Where-Object { $_.Severity -eq $Severity }
    Write-Host "  [+] After severity filter ('$Severity'): $($FilteredAlerts.Count) alerts" -ForegroundColor White
}

if ($FilteredAlerts.Count -eq 0) {
    Write-Host "  [!] No alerts match the specified filters." -ForegroundColor Yellow
    Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue
    exit 0
}

Write-Host "  [+] Alerts to export: $($FilteredAlerts.Count)" -ForegroundColor Green
#endregion

#region Severity Breakdown
Write-Host ""
Write-Host "  Severity Breakdown:" -ForegroundColor White
$SeverityGroups = $FilteredAlerts | Group-Object -Property Severity
foreach ($Group in $SeverityGroups | Sort-Object Name) {
    $SeverityColor = switch ($Group.Name) {
        "High"   { "Red" }
        "Medium" { "Yellow" }
        "Low"    { "Green" }
        default  { "White" }
    }
    Write-Host ("    {0,-10}: {1}" -f $Group.Name, $Group.Count) -ForegroundColor $SeverityColor
}
Write-Host ""
#endregion

#region Build Report Object
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 4 — Building Report" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

# Build a structured report object for each alert.
# Select and rename fields to be meaningful for investigation documentation.
$Report = $FilteredAlerts | Select-Object @(
    @{ Name = "AlertID";           Expression = { $_.AlertId } }
    @{ Name = "AlertName";         Expression = { $_.Name } }
    @{ Name = "PolicyName";        Expression = { $_.PolicyName } }
    @{ Name = "Severity";          Expression = { $_.Severity } }
    @{ Name = "Status";            Expression = { $_.Status } }
    @{ Name = "Category";          Expression = { $_.Category } }
    @{ Name = "AlertTime_UTC";     Expression = { $_.CreatedTime } }
    @{ Name = "LastUpdated_UTC";   Expression = { $_.LastUpdatedTime } }
    @{ Name = "UserEmail";         Expression = { $_.UserEmail } }
    @{ Name = "Workload";          Expression = { $_.Workload } }
    @{ Name = "EntityType";        Expression = { $_.EntityType } }
    @{ Name = "NotificationSent";  Expression = { $_.NotificationSent } }
    @{ Name = "AlertDescription";  Expression = { $_.Description } }
    @{ Name = "AlertSource";       Expression = { $_.Source } }
    @{ Name = "TenantId";          Expression = { $_.TenantId } }
    @{ Name = "ReportGenerated";   Expression = { Get-Date -Format "yyyy-MM-dd HH:mm:ss" } }
    @{ Name = "ReportedBy";        Expression = { "Get-DLPAlertReport.ps1 | Crestline Retail Group IT" } }
)

Write-Host "  [+] Report object built for $($Report.Count) alerts" -ForegroundColor Green
#endregion

#region Export to CSV
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 5 — Exporting to CSV" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

# Construct filename with date stamp and optional policy/severity tags for easy identification.
$FileTag = "DLPAlerts"
if ($PolicyName) { $FileTag += "_Policy-$($PolicyName -replace '[^a-zA-Z0-9]','-')" }
if ($Severity)   { $FileTag += "_Severity-$Severity" }

$OutputFile = Join-Path -Path $OutputPath -ChildPath "CrestlineRetailGroup_${FileTag}_${DateStamp}.csv"

try {
    $Report | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
    Write-Host "  [+] Report exported successfully" -ForegroundColor Green
    Write-Host "      File: $OutputFile" -ForegroundColor White
} catch {
    Write-Host "  [!] Failed to export CSV: $($_.Exception.Message)" -ForegroundColor Red
}
#endregion

#region Export Summary Text
$SummaryFile = Join-Path -Path $OutputPath -ChildPath "CrestlineRetailGroup_DLPAlertSummary_${DateStamp}.txt"

$SummaryLines = @"
====================================================
DLP ALERT REPORT SUMMARY — CRESTLINE RETAIL GROUP
====================================================
Generated       : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Phase           : 9 — Microsoft Purview DLP Investigation Runbook
Regulatory      : PIPEDA, Canadian PII Compliance
Environment     : Fictional 300-user, 6-site Microsoft 365 E5 scenario

QUERY PARAMETERS
  Date Range    : $($StartDate.ToString('yyyy-MM-dd')) to $($EndDate.ToString('yyyy-MM-dd'))
  Policy Filter : $(if ($PolicyName) { $PolicyName } else { 'All policies' })
  Severity      : $(if ($Severity) { $Severity } else { 'All severities' })

RESULTS
  Total Alerts  : $($Report.Count)

SEVERITY BREAKDOWN
$(($SeverityGroups | Sort-Object Name | ForEach-Object { "  {0,-10}: {1}" -f $_.Name, $_.Count }) -join "`n")

REPORT FILE
  $OutputFile

INVESTIGATOR
  Name          : Md Rahat Islam Anik
  Role          : Portfolio Lab Administrator
  Organization  : Crestline Retail Group

Generated By    : Get-DLPAlertReport.ps1
Repository      : Enterprise-IT-Security-Operations-Toolkit
====================================================
"@

try {
    $SummaryLines | Out-File -FilePath $SummaryFile -Encoding UTF8
    Write-Host "  [+] Summary exported: $SummaryFile" -ForegroundColor Green
} catch {
    Write-Host "  [!] Failed to export summary: $($_.Exception.Message)" -ForegroundColor Yellow
}
#endregion

#region Disconnect
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 6 — Disconnecting" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

try {
    Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "  [+] Disconnected from Security and Compliance PowerShell" -ForegroundColor Green
} catch {
    Write-Host "  [i] Session disconnect completed" -ForegroundColor Gray
}
#endregion

#region Final Summary
Write-Host ""
Write-Host "=============================================================" -ForegroundColor DarkGray
Write-Host "  DLP ALERT REPORT — COMPLETE" -ForegroundColor Yellow
Write-Host "=============================================================" -ForegroundColor DarkGray
Write-Host "  Alerts Exported : $($Report.Count)" -ForegroundColor White
Write-Host "  Report File     : $OutputFile" -ForegroundColor White
Write-Host "  Summary File    : $SummaryFile" -ForegroundColor White
Write-Host ""
Write-Host "  Phase 11 — Crestline Retail Group DLP Investigation Runbook" -ForegroundColor Cyan
Write-Host ""
#endregion
