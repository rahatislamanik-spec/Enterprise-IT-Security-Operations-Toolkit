# =============================================================
#  byod-access-policy-audit.ps1
#  Phase 4 - BYOD Conditional Access Governance
#  Enterprise-IT-Security-Operations-Toolkit
#  Author: Md Rahat Islam Anik
#  Description: Audits Conditional Access policies targeting
#  BYOD/personal devices, unmanaged devices, and policies
#  requiring device compliance as a grant control.
# =============================================================

# Connect
Write-Host "`n🔐 Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "Policy.Read.All" -NoWelcome

# Fetch CA Policies
Write-Host "📋 Fetching Conditional Access policies..." -ForegroundColor Cyan
$Policies = Get-MgIdentityConditionalAccessPolicy -All
Write-Host "   Found $($Policies.Count) policy/policies`n" -ForegroundColor Green

# Build Report
$Report = foreach ($Policy in $Policies) {
    $GrantControls   = $Policy.GrantControls.BuiltInControls -join ", "
    $DeviceFilter    = $Policy.Conditions.Devices.DeviceFilter.Rule
    $DeviceStates    = $Policy.Conditions.Devices.IncludeDeviceStates -join ", "
    $RequiresComp    = if ($GrantControls -like "*compliantDevice*") { "Yes" } else { "No" }
    $BlocksUnmanaged = if ($DeviceFilter -like "*isCompliant*" -or $DeviceStates -like "*compliant*") { "Yes" } else { "No" }
    $TargetsBYOD     = if ($DeviceFilter -like "*deviceOwnership*" -or $DeviceFilter -like "*Personal*") { "Yes" } else { "No" }

    [PSCustomObject]@{
        PolicyName       = $Policy.DisplayName
        State            = $Policy.State
        RequiresCompliant = $RequiresComp
        TargetsBYOD      = $TargetsBYOD
        BlocksUnmanaged  = $BlocksUnmanaged
        GrantControls    = $GrantControls
        DeviceFilter     = if ($DeviceFilter) { $DeviceFilter } else { "None" }
    }
}

# Summary
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  CONDITIONAL ACCESS POLICY AUDIT SUMMARY" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Total Policies         : $($Report.Count)"
Write-Host "  Enabled                : $(($Report | Where-Object { $_.State -eq 'enabled' }).Count)" -ForegroundColor Green
Write-Host "  Report-Only            : $(($Report | Where-Object { $_.State -eq 'enabledForReportingButNotEnforced' }).Count)" -ForegroundColor Yellow
Write-Host "  Disabled               : $(($Report | Where-Object { $_.State -eq 'disabled' }).Count)" -ForegroundColor Red
Write-Host "  Requires Compliant Dev : $(($Report | Where-Object { $_.RequiresCompliant -eq 'Yes' }).Count)" -ForegroundColor Cyan
Write-Host "  Targets BYOD           : $(($Report | Where-Object { $_.TargetsBYOD -eq 'Yes' }).Count)" -ForegroundColor Cyan
Write-Host "  Blocks Unmanaged       : $(($Report | Where-Object { $_.BlocksUnmanaged -eq 'Yes' }).Count)" -ForegroundColor Cyan
Write-Host ""

# Full Table
$Report | Format-Table PolicyName, State, RequiresCompliant, TargetsBYOD, BlocksUnmanaged -AutoSize

# Export CSV
$Date = Get-Date -Format "yyyy-MM-dd"
$ReportPath = "../../reports/byod-access-policy-audit-$Date.csv"
$Report | Export-Csv -Path $ReportPath -NoTypeInformation
Write-Host "✅ Report saved to: $ReportPath" -ForegroundColor Green
Write-Host "`nDone!`n" -ForegroundColor Cyan
