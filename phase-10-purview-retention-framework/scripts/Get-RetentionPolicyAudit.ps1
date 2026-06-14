# =============================================================
#  Get-RetentionPolicyAudit.ps1
#  Phase 10 — Microsoft Purview Retention Policy Framework
#  Enterprise-IT-Security-Operations-Toolkit
#  Author: Md Rahat Islam Anik
#  Scenario: Crestline Retail Group — fictional 300-user, 6-site environment
#  Environment: Microsoft 365 E5
#  Regulatory Framework: PIPEDA, Canadian PII Compliance
#
#  Description:
#  Connects to Security and Compliance PowerShell and audits
#  the full Microsoft Purview retention posture — all retention
#  policies, their workload assignments and settings, all
#  retention labels and their configurations, and a summary of
#  content locations not covered by any retention policy.
#  Exports a full compliance audit report to CSV with timestamp.
#
#  Prerequisites:
#  - Exchange Online Management module installed
#    Install-Module ExchangeOnlineManagement -Scope CurrentUser
#  - Permissions: Compliance Administrator or Global Reader role
#    in Microsoft Purview compliance portal
#  - PowerShell 7 recommended
#
#  Usage:
#  .\Get-RetentionPolicyAudit.ps1
#  .\Get-RetentionPolicyAudit.ps1 -OutputPath "C:\Reports"
# =============================================================

#region Parameters
[CmdletBinding()]
param (
    # OutputPath: Directory where CSV and summary reports will be saved.
    # Defaults to ~/Documents/Enterprise-IT-Security-Operations-Toolkit/
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-10-purview-retention-framework/reports"
)
#endregion

#region Initialization
$DateStamp = Get-Date -Format "yyyy-MM-dd_HHmm"

Write-Host ""
Write-Host "=============================================================" -ForegroundColor DarkGray
Write-Host "  Get-RetentionPolicyAudit.ps1" -ForegroundColor Cyan
Write-Host "  Phase 10 — Microsoft Purview Retention Policy Framework" -ForegroundColor Cyan
Write-Host "  Crestline Retail Group — Microsoft 365 E5 Environment" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Audit Date : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
Write-Host "  Output     : $OutputPath" -ForegroundColor White
Write-Host ""
#endregion

#region Output Directory
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

#region Audit — Retention Policies
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 2 — Auditing Retention Policies" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Retrieving all retention policies from Purview..." -ForegroundColor White

try {
    # Get-RetentionCompliancePolicy retrieves all retention policies configured
    # in the Microsoft Purview compliance portal for this tenant.
    $RetentionPolicies = Get-RetentionCompliancePolicy -DistributionDetail

    if ($null -eq $RetentionPolicies -or $RetentionPolicies.Count -eq 0) {
        Write-Host "  [!] No retention policies found in this tenant." -ForegroundColor Yellow
    } else {
        Write-Host "  [+] Retention policies found: $($RetentionPolicies.Count)" -ForegroundColor Green
    }
} catch {
    Write-Host "  [!] Failed to retrieve retention policies: $($_.Exception.Message)" -ForegroundColor Red
    $RetentionPolicies = @()
}

# Build the retention policy audit report object.
$PolicyReport = foreach ($Policy in $RetentionPolicies) {

    # Retrieve the rules associated with this policy.
    # Rules define the retention period and action (retain, delete, etc.)
    try {
        $PolicyRules = Get-RetentionComplianceRule -Policy $Policy.Name -ErrorAction SilentlyContinue
    } catch {
        $PolicyRules = $null
    }

    # Summarize rule settings across all rules in the policy.
    $RetentionDuration = if ($PolicyRules) {
        ($PolicyRules | Select-Object -First 1).RetentionDurationDisplayHint
    } else { "No rules found" }

    $RetentionAction = if ($PolicyRules) {
        ($PolicyRules | Select-Object -First 1).RetentionComplianceAction
    } else { "No rules found" }

    $ContentMatchQuery = if ($PolicyRules) {
        ($PolicyRules | Select-Object -First 1).ContentMatchQuery
    } else { "N/A" }

    [PSCustomObject]@{
        PolicyName             = $Policy.Name
        PolicyEnabled          = $Policy.Enabled
        PolicyMode             = $Policy.Mode
        DistributionStatus     = $Policy.DistributionStatus
        ExchangeEnabled        = $Policy.ExchangeLocation.Count -gt 0
        SharePointEnabled      = $Policy.SharePointLocation.Count -gt 0
        OneDriveEnabled        = $Policy.OneDriveLocation.Count -gt 0
        TeamsChannelEnabled    = $Policy.TeamsChannelLocation.Count -gt 0
        TeamsChatEnabled       = $Policy.TeamsChatLocation.Count -gt 0
        PublicFolderEnabled    = $Policy.PublicFolderLocation.Count -gt 0
        ExchangeLocations      = ($Policy.ExchangeLocation | Select-Object -ExpandProperty Name) -join "; "
        SharePointLocations    = ($Policy.SharePointLocation | Select-Object -ExpandProperty Name) -join "; "
        RetentionDuration      = $RetentionDuration
        RetentionAction        = $RetentionAction
        ContentMatchQuery      = $ContentMatchQuery
        RuleCount              = if ($PolicyRules) { @($PolicyRules).Count } else { 0 }
        CreatedBy              = $Policy.CreatedBy
        LastModifiedTime       = $Policy.WhenChangedUTC
        PolicyGUID             = $Policy.Guid
        AuditDate              = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        AuditedBy              = "Get-RetentionPolicyAudit.ps1 | Crestline Retail Group IT"
    }
}

# Export retention policy audit report.
$PolicyReportFile = Join-Path -Path $OutputPath -ChildPath "CrestlineRetailGroup_RetentionPolicies_Audit_${DateStamp}.csv"
if ($PolicyReport) {
    try {
        $PolicyReport | Export-Csv -Path $PolicyReportFile -NoTypeInformation -Encoding UTF8
        Write-Host "  [+] Retention policy audit exported: $PolicyReportFile" -ForegroundColor Green
    } catch {
        Write-Host "  [!] Failed to export policy report: $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""
#endregion

#region Audit — Retention Labels
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 3 — Auditing Retention Labels" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Retrieving all retention labels from Purview..." -ForegroundColor White

try {
    # Get-ComplianceTag retrieves all retention labels (tags) configured in the
    # Microsoft Purview compliance portal. Labels can be applied manually by users
    # or automatically by auto-apply label policies.
    $RetentionLabels = Get-ComplianceTag

    if ($null -eq $RetentionLabels -or $RetentionLabels.Count -eq 0) {
        Write-Host "  [!] No retention labels found in this tenant." -ForegroundColor Yellow
    } else {
        Write-Host "  [+] Retention labels found: $($RetentionLabels.Count)" -ForegroundColor Green
    }
} catch {
    Write-Host "  [!] Failed to retrieve retention labels: $($_.Exception.Message)" -ForegroundColor Red
    $RetentionLabels = @()
}

# Build the retention label audit report object.
$LabelReport = foreach ($Label in $RetentionLabels) {
    [PSCustomObject]@{
        LabelName                  = $Label.Name
        LabelDisplayName           = $Label.DisplayName
        LabelEnabled               = $Label.Disabled -eq $false
        RetentionEnabled           = $Label.RetentionEnabled
        RetentionDuration          = $Label.RetentionDuration
        RetentionDurationDisplayHint = $Label.RetentionDurationDisplayHint
        RetentionAction            = $Label.RetentionAction
        RetentionTrigger           = $Label.RetentionTrigger
        IsRecordLabel              = $Label.IsRecordLabel
        IsRegulatoryRecord         = $Label.IsRegulatoryRecord
        ReviewerEmail              = ($Label.ReviewerEmail -join "; ")
        AutoApplyType              = $Label.AutoApply
        SensitiveInfoType          = ($Label.SensitiveInfoType | ForEach-Object { $_.Name }) -join "; "
        LabelComment               = $Label.Comment
        CreatedBy                  = $Label.CreatedBy
        LastModifiedTime           = $Label.WhenChangedUTC
        LabelGUID                  = $Label.Guid
        AuditDate                  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        AuditedBy                  = "Get-RetentionPolicyAudit.ps1 | Crestline Retail Group IT"
    }
}

# Export retention label audit report.
$LabelReportFile = Join-Path -Path $OutputPath -ChildPath "CrestlineRetailGroup_RetentionLabels_Audit_${DateStamp}.csv"
if ($LabelReport) {
    try {
        $LabelReport | Export-Csv -Path $LabelReportFile -NoTypeInformation -Encoding UTF8
        Write-Host "  [+] Retention label audit exported: $LabelReportFile" -ForegroundColor Green
    } catch {
        Write-Host "  [!] Failed to export label report: $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""
#endregion

#region Audit — Retention Label Policies (Published Label Scope)
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 4 — Auditing Retention Label Policies (Publish Scope)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Retrieving label publish policies..." -ForegroundColor White

try {
    # Get-RetentionCompliancePolicy with RetentionAction filter is not directly
    # available, so we retrieve label-linked policies via ComplianceTagPolicy.
    # These are the policies that publish retention labels to user locations.
    $LabelPolicies = Get-RetentionCompliancePolicy | Where-Object { $_.Type -eq "Retention" }

    Write-Host "  [+] Label policies found: $(if ($LabelPolicies) { @($LabelPolicies).Count } else { 0 })" -ForegroundColor Green
} catch {
    Write-Host "  [!] Failed to retrieve label policies: $($_.Exception.Message)" -ForegroundColor Yellow
    $LabelPolicies = @()
}
Write-Host ""
#endregion

#region Audit — Unlabeled Content Location Analysis
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 5 — Identifying Coverage Gaps" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Analyzing workload coverage across retention policies..." -ForegroundColor White

# Determine which Microsoft 365 workloads have at least one active retention policy.
# A coverage gap exists when a workload has no retention policy assigned to it.
$WorkloadCoverage = [ordered]@{
    "Exchange Online"        = ($RetentionPolicies | Where-Object { $_.ExchangeLocation.Count -gt 0 -and $_.Enabled -eq $true }).Count
    "SharePoint Online"      = ($RetentionPolicies | Where-Object { $_.SharePointLocation.Count -gt 0 -and $_.Enabled -eq $true }).Count
    "OneDrive for Business"  = ($RetentionPolicies | Where-Object { $_.OneDriveLocation.Count -gt 0 -and $_.Enabled -eq $true }).Count
    "Teams Channel Messages" = ($RetentionPolicies | Where-Object { $_.TeamsChannelLocation.Count -gt 0 -and $_.Enabled -eq $true }).Count
    "Teams Chats"            = ($RetentionPolicies | Where-Object { $_.TeamsChatLocation.Count -gt 0 -and $_.Enabled -eq $true }).Count
    "Exchange Public Folders" = ($RetentionPolicies | Where-Object { $_.PublicFolderLocation.Count -gt 0 -and $_.Enabled -eq $true }).Count
}

$CoverageReport = foreach ($Workload in $WorkloadCoverage.Keys) {
    $PolicyCount = $WorkloadCoverage[$Workload]
    $CoverageStatus = if ($PolicyCount -gt 0) { "Covered" } else { "NOT COVERED — GAP IDENTIFIED" }
    $StatusColor = if ($PolicyCount -gt 0) { "Green" } else { "Red" }

    Write-Host ("    {0,-30}: {1} active policies — {2}" -f $Workload, $PolicyCount, $CoverageStatus) -ForegroundColor $StatusColor

    [PSCustomObject]@{
        Workload       = $Workload
        ActivePolicies = $PolicyCount
        CoverageStatus = if ($PolicyCount -gt 0) { "Covered" } else { "Gap — No active retention policy" }
        Recommendation = if ($PolicyCount -eq 0) { "Create and enable a retention policy for this workload" } else { "Review policy scope to ensure all locations are included" }
        AuditDate      = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        AuditedBy      = "Get-RetentionPolicyAudit.ps1 | Crestline Retail Group IT"
    }
}

# Export coverage gap report.
$CoverageReportFile = Join-Path -Path $OutputPath -ChildPath "CrestlineRetailGroup_RetentionCoverage_Audit_${DateStamp}.csv"
if ($CoverageReport) {
    try {
        $CoverageReport | Export-Csv -Path $CoverageReportFile -NoTypeInformation -Encoding UTF8
        Write-Host ""
        Write-Host "  [+] Coverage gap report exported: $CoverageReportFile" -ForegroundColor Green
    } catch {
        Write-Host "  [!] Failed to export coverage report: $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""
#endregion

#region Export Master Summary Report
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 6 — Exporting Audit Summary" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

# Count labels marked as records (immutable retention).
$RecordLabelCount = if ($LabelReport) {
    @($LabelReport | Where-Object { $_.IsRecordLabel -eq $true }).Count
} else { 0 }

# Count labels with auto-apply sensitive information type rules configured.
$AutoApplyLabelCount = if ($LabelReport) {
    @($LabelReport | Where-Object { $_.SensitiveInfoType -ne "" -and $null -ne $_.SensitiveInfoType }).Count
} else { 0 }

# Count coverage gaps.
$CoverageGapCount = if ($CoverageReport) {
    @($CoverageReport | Where-Object { $_.ActivePolicies -eq 0 }).Count
} else { 0 }

$SummaryFile = Join-Path -Path $OutputPath -ChildPath "CrestlineRetailGroup_RetentionAudit_Summary_${DateStamp}.txt"

$SummaryContent = @"
====================================================
RETENTION POLICY FRAMEWORK AUDIT — CRESTLINE RETAIL GROUP
====================================================
Generated         : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Phase             : 10 — Microsoft Purview Retention Policy Framework
Regulatory        : PIPEDA, Canadian PII Compliance
Environment       : Fictional 300-user, 6-site Microsoft 365 E5 scenario

RETENTION POLICIES
  Total Policies  : $(@($RetentionPolicies).Count)
  Enabled         : $(@($RetentionPolicies | Where-Object { $_.Enabled -eq $true }).Count)
  Disabled        : $(@($RetentionPolicies | Where-Object { $_.Enabled -ne $true }).Count)

RETENTION LABELS
  Total Labels    : $(@($RetentionLabels).Count)
  Record Labels   : $RecordLabelCount (immutable during retention period)
  Auto-Apply      : $AutoApplyLabelCount (using sensitive information type rules)

WORKLOAD COVERAGE
$(($CoverageReport | ForEach-Object { "  {0,-30}: {1}" -f $_.Workload, $_.CoverageStatus }) -join "`n")

COVERAGE GAPS IDENTIFIED : $CoverageGapCount

REPORT FILES
  Retention Policies : $PolicyReportFile
  Retention Labels   : $LabelReportFile
  Coverage Analysis  : $CoverageReportFile
  Summary            : $SummaryFile

INVESTIGATOR
  Name              : Md Rahat Islam Anik
  Role              : Portfolio Lab Administrator
  Organization      : Crestline Retail Group

Generated By        : Get-RetentionPolicyAudit.ps1
Repository          : Enterprise-IT-Security-Operations-Toolkit
====================================================
"@

try {
    $SummaryContent | Out-File -FilePath $SummaryFile -Encoding UTF8
    Write-Host "  [+] Audit summary exported: $SummaryFile" -ForegroundColor Green
} catch {
    Write-Host "  [!] Failed to export summary: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""
#endregion

#region Disconnect
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Step 7 — Disconnecting" -ForegroundColor Cyan
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
Write-Host "  RETENTION POLICY AUDIT — COMPLETE" -ForegroundColor Yellow
Write-Host "=============================================================" -ForegroundColor DarkGray
Write-Host "  Retention Policies Audited : $(@($RetentionPolicies).Count)" -ForegroundColor White
Write-Host "  Retention Labels Audited   : $(@($RetentionLabels).Count)" -ForegroundColor White
Write-Host "  Coverage Gaps Identified   : $CoverageGapCount" -ForegroundColor $(if ($CoverageGapCount -gt 0) { "Red" } else { "Green" })
Write-Host ""
Write-Host "  Reports saved to: $OutputPath" -ForegroundColor White
Write-Host ""
Write-Host "  Phase 10 — Crestline Retail Group Retention Policy Framework" -ForegroundColor Cyan
Write-Host ""
#endregion
