# =============================================================
#  compliant-device-access-audit.ps1
#  Phase 4 - BYOD Conditional Access Governance
#  Enterprise-IT-Security-Operations-Toolkit
#  Author: Md Rahat Islam Anik
#  Description: Audits which devices are compliant vs
#  non-compliant and cross-references with Conditional Access
#  policies that depend on device compliance.
# =============================================================

# Connect
Write-Host "`n🔐 Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "Device.Read.All","DeviceManagementManagedDevices.Read.All","Policy.Read.All" -NoWelcome

# Fetch Devices
Write-Host "📋 Fetching device compliance data..." -ForegroundColor Cyan
$Devices = Get-MgDevice -All -Property DisplayName,OperatingSystem,IsCompliant,IsManaged,TrustType,DeviceOwnership,ApproximateLastSignInDateTime

# Fetch CA Policies
Write-Host "📋 Fetching Conditional Access policies..." -ForegroundColor Cyan
$Policies = Get-MgIdentityConditionalAccessPolicy -All
$CompliancePolicies = $Policies | Where-Object {
    $_.GrantControls.BuiltInControls -contains "compliantDevice"
}

Write-Host "   Devices: $($Devices.Count) | Compliance-dependent CA Policies: $($CompliancePolicies.Count)`n" -ForegroundColor Green

# Build Device Report
$Report = foreach ($Device in $Devices) {
    $Ownership = switch ($Device.DeviceOwnership) {
        "Company"  { "Corporate" }
        "Personal" { "BYOD" }
        default    { "Unknown" }
    }
    $Trust = switch ($Device.TrustType) {
        "AzureAd"   { "Entra Joined" }
        "Workplace" { "Entra Registered (BYOD)" }
        "ServerAd"  { "Hybrid Entra Joined" }
        default     { "Unknown" }
    }
    $LastSeen = if ($Device.ApproximateLastSignInDateTime) {
        $Device.ApproximateLastSignInDateTime.ToString("yyyy-MM-dd")
    } else { "Never" }

    [PSCustomObject]@{
        DeviceName    = $Device.DisplayName
        Ownership     = $Ownership
        TrustType     = $Trust
        OS            = $Device.OperatingSystem
        Compliance    = if ($Device.IsCompliant -eq $true) { "Compliant" } elseif ($Device.IsCompliant -eq $false) { "Non-Compliant" } else { "Unknown" }
        Managed       = if ($Device.IsManaged) { "Managed" } else { "Unmanaged" }
        LastSignIn    = $LastSeen
        CAImpact      = if ($Device.IsCompliant -ne $true) { "Blocked by $($CompliancePolicies.Count) CA policy/policies" } else { "Full Access" }
    }
}

# Summary
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  COMPLIANT DEVICE ACCESS AUDIT SUMMARY" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Total Devices        : $($Report.Count)"
Write-Host "  Compliant            : $(($Report | Where-Object { $_.Compliance -eq 'Compliant' }).Count)" -ForegroundColor Green
Write-Host "  Non-Compliant        : $(($Report | Where-Object { $_.Compliance -eq 'Non-Compliant' }).Count)" -ForegroundColor Red
Write-Host "  Unknown Compliance   : $(($Report | Where-Object { $_.Compliance -eq 'Unknown' }).Count)" -ForegroundColor Yellow
Write-Host "  Full Access Devices  : $(($Report | Where-Object { $_.CAImpact -eq 'Full Access' }).Count)" -ForegroundColor Green
Write-Host "  Restricted Devices   : $(($Report | Where-Object { $_.CAImpact -ne 'Full Access' }).Count)" -ForegroundColor Red
Write-Host ""
Write-Host "  CA Policies Requiring Compliance:" -ForegroundColor Cyan
$CompliancePolicies | ForEach-Object {
    Write-Host "    • $($_.DisplayName) [$($_.State)]" -ForegroundColor Gray
}
Write-Host ""

# Full Table
$Report | Format-Table DeviceName, Ownership, OS, Compliance, Managed, CAImpact -AutoSize

# Export CSV
$Date = Get-Date -Format "yyyy-MM-dd"
$ReportPath = "../../reports/compliant-device-access-audit-$Date.csv"
$Report | Export-Csv -Path $ReportPath -NoTypeInformation
Write-Host "✅ Report saved to: $ReportPath" -ForegroundColor Green
Write-Host "`nDone!`n" -ForegroundColor Cyan
