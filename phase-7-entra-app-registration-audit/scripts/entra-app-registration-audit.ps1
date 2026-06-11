# =============================================================
#  entra-app-registration-audit.ps1
#  Phase 7 — Entra ID App Registration Audit
#  Enterprise-IT-Security-Operations-Toolkit
#  Author: Md Rahat Islam Anik
#  Description: Audits all Entra ID app registrations,
#  OAuth permission grants, service principals, credential
#  expiry, and high-risk permission assignments across
#  the Microsoft 365 tenant.
# =============================================================

Connect-MgGraph -Scopes "Application.Read.All","Directory.Read.All" -NoWelcome

$Date = Get-Date -Format "yyyy-MM-dd"
$ReportPath = Join-Path $PSScriptRoot "../reports"

# ── 1. App Registrations ─────────────────────────────────────
Write-Host "`n📋 Fetching app registrations..." -ForegroundColor Cyan
$Apps = Get-MgApplication -All
Write-Host "   Total app registrations: $($Apps.Count)" -ForegroundColor Green

$AppReport = foreach ($App in $Apps) {
    $Creds = $App.PasswordCredentials + $App.KeyCredentials
    $ExpiredCreds = $Creds | Where-Object { $_.EndDateTime -lt (Get-Date) }
    $ExpiringSoon = $Creds | Where-Object { $_.EndDateTime -gt (Get-Date) -and $_.EndDateTime -lt (Get-Date).AddDays(30) }

    [PSCustomObject]@{
        AppName          = $App.DisplayName
        AppId            = $App.AppId
        SignInAudience   = $App.SignInAudience
        CreatedDateTime  = $App.CreatedDateTime
        TotalCredentials = $Creds.Count
        ExpiredCreds     = $ExpiredCreds.Count
        ExpiringSoon     = $ExpiringSoon.Count
        PublisherDomain  = $App.PublisherDomain
    }
}

# ── 2. Service Principals ────────────────────────────────────
Write-Host "`n📋 Fetching service principals..." -ForegroundColor Cyan
$SPs = Get-MgServicePrincipal -All
Write-Host "   Total service principals: $($SPs.Count)" -ForegroundColor Green

$SPReport = foreach ($SP in $SPs) {
    [PSCustomObject]@{
        DisplayName      = $SP.DisplayName
        AppId            = $SP.AppId
        ServicePrincipalType = $SP.ServicePrincipalType
        AccountEnabled   = $SP.AccountEnabled
        PublisherName    = $SP.PublisherName
        Homepage         = $SP.Homepage
    }
}

# ── 3. OAuth Permission Grants ───────────────────────────────
Write-Host "`n📋 Fetching OAuth permission grants..." -ForegroundColor Cyan
$OAuthGrants = Get-MgOauth2PermissionGrant -All
Write-Host "   Total OAuth grants: $($OAuthGrants.Count)" -ForegroundColor Green

$OAuthReport = foreach ($Grant in $OAuthGrants) {
    $SP = $SPs | Where-Object { $_.Id -eq $Grant.ClientId }
    [PSCustomObject]@{
        ClientApp    = if ($SP) { $SP.DisplayName } else { $Grant.ClientId }
        ConsentType  = $Grant.ConsentType
        Scope        = $Grant.Scope
        ResourceId   = $Grant.ResourceId
    }
}

# ── 4. High-Risk Permissions ─────────────────────────────────
Write-Host "`n📋 Analyzing high-risk permissions..." -ForegroundColor Cyan
$HighRiskScopes = @("Mail.Read","Mail.ReadWrite","Files.ReadWrite.All","User.ReadWrite.All","Directory.ReadWrite.All","RoleManagement.ReadWrite.Directory","Application.ReadWrite.All")

$HighRiskGrants = $OAuthReport | Where-Object {
    $scope = $_.Scope
    $HighRiskScopes | Where-Object { $scope -like "*$_*" }
}
Write-Host "   High-risk permission grants: $($HighRiskGrants.Count)" -ForegroundColor $(if ($HighRiskGrants.Count -gt 0) { "Red" } else { "Green" })

# ── 5. Expired Credentials Summary ──────────────────────────
$ExpiredApps = $AppReport | Where-Object { $_.ExpiredCreds -gt 0 }
$ExpiringApps = $AppReport | Where-Object { $_.ExpiringSoon -gt 0 }
$MultiTenantApps = $AppReport | Where-Object { $_.SignInAudience -ne "AzureADMyOrg" }

# ── 6. Summary Display ──────────────────────────────────────
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  ENTRA ID APP REGISTRATION AUDIT SUMMARY" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Total App Registrations    : $($Apps.Count)"
Write-Host "  Total Service Principals   : $($SPs.Count)"
Write-Host "  Total OAuth Grants         : $($OAuthGrants.Count)"
Write-Host "  High-Risk Permission Grants: $($HighRiskGrants.Count)" -ForegroundColor $(if ($HighRiskGrants.Count -gt 0) { "Red" } else { "Green" })
Write-Host "  Apps with Expired Creds    : $($ExpiredApps.Count)" -ForegroundColor $(if ($ExpiredApps.Count -gt 0) { "Yellow" } else { "Green" })
Write-Host "  Apps Expiring in 30 Days   : $($ExpiringApps.Count)" -ForegroundColor $(if ($ExpiringApps.Count -gt 0) { "Yellow" } else { "Green" })
Write-Host "  Multi-Tenant Apps          : $($MultiTenantApps.Count)" -ForegroundColor Cyan
Write-Host ""

# ── 7. Export CSV Reports ────────────────────────────────────
$AppReport      | Export-Csv "$ReportPath/app-registrations-audit-$Date.csv" -NoTypeInformation
$SPReport       | Export-Csv "$ReportPath/service-principals-audit-$Date.csv" -NoTypeInformation
$OAuthReport    | Export-Csv "$ReportPath/oauth-permission-grants-$Date.csv" -NoTypeInformation
$HighRiskGrants | Export-Csv "$ReportPath/high-risk-permissions-$Date.csv" -NoTypeInformation

Write-Host "✅ Reports saved to: $ReportPath" -ForegroundColor Green
Write-Host "`nDone!`n" -ForegroundColor Cyan
