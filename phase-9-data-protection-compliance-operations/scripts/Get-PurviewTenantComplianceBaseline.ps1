#Requires -Version 7.0

<#
.SYNOPSIS
    Collects a read-only Microsoft Purview governance configuration baseline.

.DESCRIPTION
    Connects to Security & Compliance PowerShell and inventories sensitivity
    labels, label publishing policies, DLP policies and rules, retention
    policies, retention rules, and retention labels. Endpoint DLP is assessed
    only from properties exposed by the available DLP policy cmdlets.

    The script reports configuration state. It does not determine regulatory
    compliance, prove policy enforcement, or claim that endpoint controls are
    active when the connected session does not expose sufficient evidence.

.PARAMETER UserPrincipalName
    Optional administrator UPN supplied to Connect-IPPSSession. When omitted,
    the module uses its normal interactive sign-in flow.

.PARAMETER OutputPath
    Directory used for timestamped TXT, CSV, and JSON reports. The default is
    a reports folder beside the Phase 9 scripts folder.

.PARAMETER AccessToken
    Optional OAuth access token for Security & Compliance PowerShell. Use this
    only when a token has been obtained through an approved device-code or
    application authentication workflow. The token is never written to reports.

.EXAMPLE
    ./Get-PurviewTenantComplianceBaseline.ps1

.EXAMPLE
    ./Get-PurviewTenantComplianceBaseline.ps1 -UserPrincipalName admin@contoso.com

.NOTES
    Requires PowerShell 7 and the ExchangeOnlineManagement module.
    Required Purview permissions vary by cmdlet and tenant configuration.
#>

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$UserPrincipalName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath = (Join-Path (Split-Path $PSScriptRoot -Parent) "reports"),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$AccessToken
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:AuditRecords = [System.Collections.Generic.List[object]]::new()
$script:AuditIssues = [System.Collections.Generic.List[object]]::new()
$script:Connected = $false
$script:RunStarted = Get-Date
$dateStamp = $script:RunStarted.ToString("yyyy-MM-dd_HHmmss")

function ConvertTo-ReportValue {
    [CmdletBinding()]
    param([AllowNull()][object]$Value)

    if ($null -eq $Value) {
        return "Not exposed"
    }

    if ($Value -is [string] -or $Value -is [ValueType]) {
        return [string]$Value
    }

    if ($Value -is [System.Collections.IDictionary]) {
        return ($Value | ConvertTo-Json -Compress -Depth 4)
    }

    if ($Value -is [System.Collections.IEnumerable]) {
        $items = foreach ($item in $Value) {
            if ($null -eq $item) {
                continue
            }

            $displayProperty = $item.PSObject.Properties["DisplayName"]
            $nameProperty = $item.PSObject.Properties["Name"]

            if ($displayProperty -and $displayProperty.Value) {
                [string]$displayProperty.Value
            }
            elseif ($nameProperty -and $nameProperty.Value) {
                [string]$nameProperty.Value
            }
            else {
                [string]$item
            }
        }

        if (@($items).Count -eq 0) {
            return "None"
        }

        return ($items -join "; ")
    }

    return [string]$Value
}

function Get-FirstPropertyValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$InputObject,
        [Parameter(Mandatory)][string[]]$PropertyName,
        [string]$Default = "Not exposed"
    )

    foreach ($name in $PropertyName) {
        $property = $InputObject.PSObject.Properties[$name]
        if ($property -and $null -ne $property.Value) {
            return (ConvertTo-ReportValue -Value $property.Value)
        }
    }

    return $Default
}

function Test-PropertyHasValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$InputObject,
        [Parameter(Mandatory)][string[]]$PropertyName
    )

    foreach ($name in $PropertyName) {
        $property = $InputObject.PSObject.Properties[$name]
        if (-not $property -or $null -eq $property.Value) {
            continue
        }

        if ($property.Value -is [string]) {
            if (-not [string]::IsNullOrWhiteSpace($property.Value)) {
                return $true
            }
            continue
        }

        if ($property.Value -is [System.Collections.IEnumerable]) {
            if (@($property.Value).Count -gt 0) {
                return $true
            }
            continue
        }

        if ([bool]$property.Value) {
            return $true
        }
    }

    return $false
}

function Add-AuditRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Pillar,
        [Parameter(Mandatory)][string]$RecordType,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Status,
        [Parameter(Mandatory)][string]$Details
    )

    $script:AuditRecords.Add([PSCustomObject]@{
        Pillar     = $Pillar
        RecordType = $RecordType
        Name       = $Name
        Status     = $Status
        Details    = $Details
    })
}

function Add-AuditIssue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Pillar,
        [Parameter(Mandatory)][string]$Message
    )

    $script:AuditIssues.Add([PSCustomObject]@{
        Pillar = $Pillar
        Message = $Message
    })

    Write-Warning "[$Pillar] $Message"
}

function Test-ComplianceCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Pillar
    )

    if (Get-Command -Name $Name -ErrorAction SilentlyContinue) {
        return $true
    }

    Add-AuditIssue -Pillar $Pillar -Message "$Name is unavailable in the connected session. The section was not verified."
    return $false
}

function Get-DlpWorkloads {
    [CmdletBinding()]
    param([Parameter(Mandatory)][object]$Policy)

    $workloadProperties = [ordered]@{
        Exchange   = @("ExchangeLocation")
        SharePoint = @("SharePointLocation")
        OneDrive   = @("OneDriveLocation")
        Teams      = @("TeamsLocation", "TeamsChatLocation", "TeamsChannelLocation")
        Devices    = @("EndpointDlpLocation", "EndpointLocation", "DevicesLocation")
        PowerBI    = @("PowerBILocation")
    }

    $workloads = foreach ($workload in $workloadProperties.Keys) {
        if (Test-PropertyHasValue -InputObject $Policy -PropertyName $workloadProperties[$workload]) {
            $workload
        }
    }

    if (@($workloads).Count -eq 0) {
        return "No workload property exposed"
    }

    return ($workloads -join ", ")
}

function Invoke-InformationProtectionAudit {
    Write-Host "[1/4] Information Protection" -ForegroundColor Cyan

    if (Test-ComplianceCommand -Name "Get-Label" -Pillar "Information Protection") {
        try {
            $labels = @(Get-Label)
            foreach ($label in $labels) {
                $name = Get-FirstPropertyValue -InputObject $label -PropertyName @("DisplayName", "Name")
                $status = Get-FirstPropertyValue -InputObject $label -PropertyName @("Disabled", "Mode", "State")
                $priority = Get-FirstPropertyValue -InputObject $label -PropertyName @("Priority")
                $encryption = Get-FirstPropertyValue -InputObject $label -PropertyName @("EncryptionEnabled", "EncryptionProtectionType")
                $scope = Get-FirstPropertyValue -InputObject $label -PropertyName @("ContentType", "Scope")

                Add-AuditRecord -Pillar "Information Protection" -RecordType "Sensitivity Label" -Name $name -Status $status -Details "Priority=$priority; Encryption=$encryption; Scope=$scope"
            }

            if ($labels.Count -eq 0) {
                Add-AuditRecord -Pillar "Information Protection" -RecordType "Sensitivity Label" -Name "No labels returned" -Status "Observed" -Details "The query completed but returned no sensitivity labels."
            }
        }
        catch {
            Add-AuditIssue -Pillar "Information Protection" -Message "Sensitivity labels could not be queried: $($_.Exception.Message)"
        }
    }

    if (Test-ComplianceCommand -Name "Get-LabelPolicy" -Pillar "Information Protection") {
        try {
            $policies = @(Get-LabelPolicy)
            foreach ($policy in $policies) {
                $name = Get-FirstPropertyValue -InputObject $policy -PropertyName @("Name", "DisplayName")
                $status = Get-FirstPropertyValue -InputObject $policy -PropertyName @("Enabled", "Mode", "State")
                $labelProperty = $policy.PSObject.Properties["Labels"]
                if (-not $labelProperty) {
                    $labelProperty = $policy.PSObject.Properties["ScopedLabels"]
                }
                $labelCount = if ($labelProperty -and $null -ne $labelProperty.Value) {
                    @($labelProperty.Value).Count
                }
                else {
                    "Not exposed"
                }

                $scopeCategories = foreach ($scopeProperty in @("ExchangeLocation", "SharePointLocation", "OneDriveLocation", "ModernGroupLocation")) {
                    if (Test-PropertyHasValue -InputObject $policy -PropertyName @($scopeProperty)) {
                        $scopeProperty
                    }
                }
                $scope = if (@($scopeCategories).Count -gt 0) {
                    $scopeCategories -join ", "
                }
                else {
                    "No location property exposed"
                }

                Add-AuditRecord -Pillar "Information Protection" -RecordType "Label Publishing Policy" -Name $name -Status $status -Details "LabelCount=$labelCount; ScopeCategories=$scope"
            }
        }
        catch {
            Add-AuditIssue -Pillar "Information Protection" -Message "Label publishing policies could not be queried: $($_.Exception.Message)"
        }
    }
}

function Invoke-DlpAudit {
    Write-Host "[2/4] Data Loss Prevention" -ForegroundColor Cyan

    if (-not (Test-ComplianceCommand -Name "Get-DlpCompliancePolicy" -Pillar "Data Loss Prevention")) {
        return
    }

    try {
        $policies = @(Get-DlpCompliancePolicy)
    }
    catch {
        Add-AuditIssue -Pillar "Data Loss Prevention" -Message "DLP policies could not be queried: $($_.Exception.Message)"
        return
    }

    $canQueryRules = Test-ComplianceCommand -Name "Get-DlpComplianceRule" -Pillar "Data Loss Prevention"

    foreach ($policy in $policies) {
        $name = Get-FirstPropertyValue -InputObject $policy -PropertyName @("Name", "DisplayName")
        $status = Get-FirstPropertyValue -InputObject $policy -PropertyName @("Mode", "Enabled", "State")
        $workloads = Get-DlpWorkloads -Policy $policy
        $distribution = Get-FirstPropertyValue -InputObject $policy -PropertyName @("DistributionStatus")

        Add-AuditRecord -Pillar "Data Loss Prevention" -RecordType "DLP Policy" -Name $name -Status $status -Details "Workloads=$workloads; DistributionStatus=$distribution"

        if (-not $canQueryRules) {
            continue
        }

        try {
            $rules = @(Get-DlpComplianceRule -Policy $name)
            foreach ($rule in $rules) {
                $ruleName = Get-FirstPropertyValue -InputObject $rule -PropertyName @("Name", "DisplayName")
                $ruleStatus = Get-FirstPropertyValue -InputObject $rule -PropertyName @("Disabled", "Mode", "State")
                $block = Get-FirstPropertyValue -InputObject $rule -PropertyName @("BlockAccess", "BlockAccessScope")
                $notify = Get-FirstPropertyValue -InputObject $rule -PropertyName @("NotifyUser", "GenerateIncidentReport")
                $override = Get-FirstPropertyValue -InputObject $rule -PropertyName @("NotifyAllowOverride", "AllowOverride")

                Add-AuditRecord -Pillar "Data Loss Prevention" -RecordType "DLP Rule" -Name $ruleName -Status $ruleStatus -Details "Policy=$name; Block=$block; Notification=$notify; Override=$override"
            }
        }
        catch {
            Add-AuditIssue -Pillar "Data Loss Prevention" -Message "Rules for DLP policy '$name' could not be queried: $($_.Exception.Message)"
        }
    }

    if ($policies.Count -eq 0) {
        Add-AuditRecord -Pillar "Data Loss Prevention" -RecordType "DLP Policy" -Name "No policies returned" -Status "Observed" -Details "The query completed but returned no DLP policies."
    }
}

function Invoke-RetentionAudit {
    Write-Host "[3/4] Data Lifecycle Management" -ForegroundColor Cyan

    if (Test-ComplianceCommand -Name "Get-RetentionCompliancePolicy" -Pillar "Data Lifecycle Management") {
        try {
            $policies = @(Get-RetentionCompliancePolicy -DistributionDetail)
            $canQueryRules = Test-ComplianceCommand -Name "Get-RetentionComplianceRule" -Pillar "Data Lifecycle Management"

            foreach ($policy in $policies) {
                $name = Get-FirstPropertyValue -InputObject $policy -PropertyName @("Name", "DisplayName")
                $status = Get-FirstPropertyValue -InputObject $policy -PropertyName @("Enabled", "Mode", "State")
                $lock = Get-FirstPropertyValue -InputObject $policy -PropertyName @("RestrictiveRetention", "PreservationLock", "IsRestrictiveRetention")
                $distribution = Get-FirstPropertyValue -InputObject $policy -PropertyName @("DistributionStatus")

                Add-AuditRecord -Pillar "Data Lifecycle Management" -RecordType "Retention Policy" -Name $name -Status $status -Details "PreservationLockProperty=$lock; DistributionStatus=$distribution"

                if (-not $canQueryRules) {
                    continue
                }

                try {
                    $rules = @(Get-RetentionComplianceRule -Policy $name)
                    foreach ($rule in $rules) {
                        $ruleName = Get-FirstPropertyValue -InputObject $rule -PropertyName @("Name", "DisplayName")
                        $duration = Get-FirstPropertyValue -InputObject $rule -PropertyName @("RetentionDuration", "RetentionDurationDisplayHint")
                        $action = Get-FirstPropertyValue -InputObject $rule -PropertyName @("RetentionComplianceAction", "RetentionAction")
                        $trigger = Get-FirstPropertyValue -InputObject $rule -PropertyName @("RetentionTrigger", "ExpirationDateOption")

                        Add-AuditRecord -Pillar "Data Lifecycle Management" -RecordType "Retention Rule" -Name $ruleName -Status "Observed" -Details "Policy=$name; Duration=$duration; Action=$action; Trigger=$trigger"
                    }
                }
                catch {
                    Add-AuditIssue -Pillar "Data Lifecycle Management" -Message "Rules for retention policy '$name' could not be queried: $($_.Exception.Message)"
                }
            }
        }
        catch {
            Add-AuditIssue -Pillar "Data Lifecycle Management" -Message "Retention policies could not be queried: $($_.Exception.Message)"
        }
    }

    if (Test-ComplianceCommand -Name "Get-ComplianceTag" -Pillar "Data Lifecycle Management") {
        try {
            $labels = @(Get-ComplianceTag)
            foreach ($label in $labels) {
                $name = Get-FirstPropertyValue -InputObject $label -PropertyName @("DisplayName", "Name")
                $status = Get-FirstPropertyValue -InputObject $label -PropertyName @("Disabled", "RetentionEnabled")
                $duration = Get-FirstPropertyValue -InputObject $label -PropertyName @("RetentionDuration", "RetentionDurationDisplayHint")
                $action = Get-FirstPropertyValue -InputObject $label -PropertyName @("RetentionAction")
                $record = Get-FirstPropertyValue -InputObject $label -PropertyName @("IsRegulatoryRecord", "IsRecordLabel")

                Add-AuditRecord -Pillar "Data Lifecycle Management" -RecordType "Retention Label" -Name $name -Status $status -Details "Duration=$duration; Action=$action; RecordLabel=$record"
            }
        }
        catch {
            Add-AuditIssue -Pillar "Data Lifecycle Management" -Message "Retention labels could not be queried: $($_.Exception.Message)"
        }
    }
}

function Invoke-EndpointDlpAssessment {
    Write-Host "[4/4] Endpoint DLP Scope Assessment" -ForegroundColor Cyan

    $endpointPolicies = @($script:AuditRecords | Where-Object {
        $_.RecordType -eq "DLP Policy" -and $_.Details -match "Workloads=.*Devices"
    })

    if ($endpointPolicies.Count -gt 0) {
        Add-AuditRecord -Pillar "Endpoint DLP" -RecordType "Policy Scope" -Name "Endpoint workload referenced" -Status "Observed" -Details "$($endpointPolicies.Count) DLP policy record(s) exposed a device or endpoint workload property. Device onboarding and enforcement remain unverified."
    }
    else {
        Add-AuditRecord -Pillar "Endpoint DLP" -RecordType "Policy Scope" -Name "Endpoint configuration" -Status "Not verified" -Details "No device workload property was exposed by the queried DLP policy objects. Review Endpoint DLP settings and device onboarding in the Purview portal."
    }

    Add-AuditRecord -Pillar "Endpoint DLP" -RecordType "Global Settings" -Name "Browser and network restrictions" -Status "Not queried" -Details "This baseline does not use undocumented tenant-global Endpoint DLP cmdlets. Validate browser restrictions, network exclusions, and device onboarding separately in the Purview portal."
}

function Export-BaselineReports {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Destination)

    if (-not (Test-Path -LiteralPath $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    $csvPath = Join-Path $Destination "Purview_Compliance_Baseline_$dateStamp.csv"
    $jsonPath = Join-Path $Destination "Purview_Compliance_Baseline_$dateStamp.json"
    $summaryPath = Join-Path $Destination "Purview_Compliance_Baseline_$dateStamp.txt"

    $script:AuditRecords | Export-Csv -Path $csvPath -NoTypeInformation -Encoding utf8

    $jsonReport = [ordered]@{
        ReportType = "Microsoft Purview governance configuration baseline"
        GeneratedAt = (Get-Date).ToString("o")
        PowerShellVersion = $PSVersionTable.PSVersion.ToString()
        RecordCount = $script:AuditRecords.Count
        IssueCount = $script:AuditIssues.Count
        Records = $script:AuditRecords
        Issues = $script:AuditIssues
        Limitations = @(
            "This report inventories configuration exposed to the connected account."
            "It is not a regulatory compliance determination or proof of enforcement."
            "Endpoint DLP device onboarding and tenant-global settings require separate validation."
        )
    }
    $jsonReport | ConvertTo-Json -Depth 8 | Set-Content -Path $jsonPath -Encoding utf8

    $counts = $script:AuditRecords | Group-Object -Property Pillar | Sort-Object Name
    $summary = [System.Collections.Generic.List[string]]::new()
    $summary.Add("MICROSOFT PURVIEW GOVERNANCE CONFIGURATION BASELINE")
    $summary.Add("Generated: $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz'))")
    $summary.Add("Records: $($script:AuditRecords.Count)")
    $summary.Add("Issues or unverified areas: $($script:AuditIssues.Count)")
    $summary.Add("")
    $summary.Add("PILLAR COUNTS")
    foreach ($count in $counts) {
        $summary.Add("- $($count.Name): $($count.Count)")
    }
    $summary.Add("")
    $summary.Add("LIMITATIONS")
    $summary.Add("- Configuration inventory only; no regulatory compliance conclusion is made.")
    $summary.Add("- Policy presence does not prove enforcement, user adoption, or control effectiveness.")
    $summary.Add("- Endpoint DLP onboarding and global settings require separate portal validation.")

    if ($script:AuditIssues.Count -gt 0) {
        $summary.Add("")
        $summary.Add("ISSUES OR UNVERIFIED AREAS")
        foreach ($issue in $script:AuditIssues) {
            $summary.Add("- [$($issue.Pillar)] $($issue.Message)")
        }
    }

    $summary | Set-Content -Path $summaryPath -Encoding utf8

    return [PSCustomObject]@{
        Csv = $csvPath
        Json = $jsonPath
        Summary = $summaryPath
    }
}

Write-Host "Microsoft Purview Governance Configuration Baseline" -ForegroundColor Cyan
Write-Host "Read-only inventory; no compliance or enforcement conclusion is produced." -ForegroundColor Yellow

try {
    $module = Get-Module -ListAvailable -Name ExchangeOnlineManagement |
        Sort-Object Version -Descending |
        Select-Object -First 1

    if (-not $module) {
        throw "ExchangeOnlineManagement is not installed. Run: Install-Module ExchangeOnlineManagement -Scope CurrentUser"
    }

    Import-Module ExchangeOnlineManagement -MinimumVersion $module.Version

    $connectionParameters = @{ ShowBanner = $false }
    if ($UserPrincipalName) {
        $connectionParameters.UserPrincipalName = $UserPrincipalName
    }
    if ($AccessToken) {
        if (-not $UserPrincipalName) {
            throw "UserPrincipalName is required when AccessToken is supplied."
        }
        $connectionParameters.AccessToken = $AccessToken
    }

    Connect-IPPSSession @connectionParameters
    $script:Connected = $true

    Invoke-InformationProtectionAudit
    Invoke-DlpAudit
    Invoke-RetentionAudit
    Invoke-EndpointDlpAssessment

    $reports = Export-BaselineReports -Destination $OutputPath

    Write-Host "Baseline collection completed." -ForegroundColor Green
    Write-Host "Records: $($script:AuditRecords.Count) | Issues/unverified: $($script:AuditIssues.Count)" -ForegroundColor White
    Write-Host "Summary: $($reports.Summary)" -ForegroundColor White
    Write-Host "CSV:     $($reports.Csv)" -ForegroundColor White
    Write-Host "JSON:    $($reports.Json)" -ForegroundColor White
}
catch {
    $message = $_.Exception.Message
    if ($message -match "PlatformNotSupportedException|macOS") {
        Write-Error "Purview interactive authentication is unsupported in the tested macOS 26.5.1 and ExchangeOnlineManagement 3.9.2 environment. Run this script from a supported Windows PowerShell 7 environment, or supply -UserPrincipalName and an approved Security & Compliance PowerShell access token with -AccessToken. Original error: $message"
    }
    else {
        Write-Error "Purview baseline collection failed: $message"
    }
    exit 1
}
finally {
    if ($script:Connected -and (Get-Command -Name Disconnect-ExchangeOnline -ErrorAction SilentlyContinue)) {
        try {
            Disconnect-ExchangeOnline -Confirm:$false -ErrorAction Stop
            Write-Host "Security & Compliance PowerShell session disconnected." -ForegroundColor DarkGray
        }
        catch {
            Write-Warning "The session could not be cleanly disconnected: $($_.Exception.Message)"
        }
    }
}
