# =============================================================
#  web-only-access-policy-audit.ps1
#  Phase 6 — Web-Only Access Governance for Unmanaged Devices
#  Enterprise-IT-Security-Operations-Toolkit
#  Author: Md Rahat Islam Anik
#  Description: Audits and reports on Conditional Access
#  policies enforcing web-only/browser-only access for
#  unmanaged and non-compliant devices via session controls
#  and app-enforced restrictions.
# =============================================================

# Connect
Write-Host "`n🔐 Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "Policy.Read.All","Device.Read.All","Application.Read.All" -NoWelcome

$Date = Get-Date -Format "yyyy-MM-dd"
$ReportPath = Join-Path $PSScriptRoot "../reports"

# ── 1. Fetch All CA Policies ─────────────────────────────────
Write-Host "`n📋 Fetching Conditional Access policies..." -ForegroundColor Cyan
$Policies = Get-MgIdentityConditionalAccessPolicy -All
Write-Host "   Total policies found: $($Policies.Count)" -ForegroundColor Green

# ── 2. Identify Web-Only / Session Control Policies ──────────
Write-Host "`n📋 Analyzing session control policies..." -ForegroundColor Cyan

$PolicyReport = foreach ($Policy in $Policies) {
    $SessionControls = $Policy.SessionControls
    $GrantControls   = $Policy.GrantControls
    $Conditions      = $Policy.Conditions

    $HasAppRestrictions     = $SessionControls.ApplicationEnforcedRestrictions.IsEnabled
    $HasCAAS                = $SessionControls.CloudAppSecurity.IsEnabled
    $HasSignInFrequency     = $null -ne $SessionControls.SignInFrequency
    $HasPersistentBrowser   = $null -ne $SessionControls.PersistentBrowser
    $RequiresCompliant      = $GrantControls.BuiltInControls -contains "compliantDevice"
    $RequiresDomainJoined   = $GrantControls.BuiltInControls -contains "domainJoinedDevice"

    $DeviceFilter = $Conditions.Devices.DeviceFilter.Rule
    $TargetApps   = if ($Conditions.Applications.IncludeApplications) {
        $Conditions.Applications.IncludeApplications -join ", "
    } else { "All Apps" }

    $SessionType = "None"
    if ($HasAppRestrictions) { $SessionType = "App-Enforced Restrictions (Web-Only)" }
    elseif ($HasCAAS) { $SessionType = "Cloud App Security Session" }
    elseif ($HasSignInFrequency) { $SessionType = "Sign-in Frequency Control" }
    elseif ($HasPersistentBrowser) { $SessionType = "Persistent Browser Control" }

    [PSCustomObject]@{
        PolicyName            = $Policy.DisplayName
        State                 = $Policy.State
        SessionControl        = $SessionType
        AppEnforcedRestrict   = if ($HasAppRestrictions) { "Yes" } else { "No" }
        CloudAppSecurity      = if ($HasCAAS) { "Yes" } else { "No" }
        SignInFrequency       = if ($HasSignInFrequency) { "Yes" } else { "No" }
        RequiresCompliant     = if ($RequiresCompliant) { "Yes" } else { "No" }
        RequiresDomainJoined  = if ($RequiresDomainJoined) { "Yes" } else { "No" }
        DeviceFilter          = if ($DeviceFilter) { $DeviceFilter } else { "None" }
        TargetApps            = $TargetApps
    }
}

# ── 3. Web-Only Policy Summary ───────────────────────────────
$WebOnlyPolicies    = $PolicyReport | Where-Object { $_.AppEnforcedRestrict -eq "Yes" }
$SessionPolicies    = $PolicyReport | Where-Object { $_.SessionControl -ne "None" }
$EnabledPolicies    = $PolicyReport | Where-Object { $_.State -eq "enabled" }
$ReportOnlyPolicies = $PolicyReport | Where-Object { $_.State -eq "enabledForReportingButNotEnforced" }

# ── 4. Display Summary ───────────────────────────────────────
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  WEB-ONLY ACCESS GOVERNANCE AUDIT SUMMARY" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Total CA Policies              : $($PolicyReport.Count)"
Write-Host "  Enabled Policies               : $($EnabledPolicies.Count)" -ForegroundColor Green
Write-Host "  Report-Only Policies           : $($ReportOnlyPolicies.Count)" -ForegroundColor Yellow
Write-Host "  Policies with Session Controls : $($SessionPolicies.Count)" -ForegroundColor Cyan
Write-Host "  Web-Only (App Restrictions)    : $($WebOnlyPolicies.Count)" -ForegroundColor Cyan
Write-Host ""

if ($WebOnlyPolicies.Count -gt 0) {
    Write-Host "  Web-Only Policies:" -ForegroundColor Cyan
    $WebOnlyPolicies | ForEach-Object {
        Write-Host "    • $($_.PolicyName) [$($_.State)]" -ForegroundColor Gray
    }
} else {
    Write-Host "  ⚠️  No web-only app-enforced restriction policies found." -ForegroundColor Yellow
    Write-Host "     Recommendation: Create a CA policy with app-enforced restrictions" -ForegroundColor Yellow
    Write-Host "     targeting unmanaged devices for SharePoint and Exchange Online." -ForegroundColor Yellow
}
Write-Host ""

# ── 5. Full Policy Table ─────────────────────────────────────
Write-Host "  Full Policy Summary:" -ForegroundColor White
$PolicyReport | Format-Table PolicyName, State, SessionControl, AppEnforcedRestrict, RequiresCompliant -AutoSize

# ── 6. Export CSV ────────────────────────────────────────────
$PolicyReport | Export-Csv "$ReportPath/web-only-access-policy-audit-$Date.csv" -NoTypeInformation
Write-Host "✅ Report saved to: $ReportPath" -ForegroundColor Green
Write-Host "`nDone!`n" -ForegroundColor Cyan
