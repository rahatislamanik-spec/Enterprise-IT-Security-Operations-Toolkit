# =============================================================
#  byod-device-inventory.ps1
#  Phase 4 - BYOD Conditional Access Governance
#  Enterprise-IT-Security-Operations-Toolkit
#  Author: Md Rahat Islam Anik
#  Description: Inventories all Entra ID registered/joined
#  devices, classifying by ownership, compliance, trust type
# =============================================================

# Connect
Write-Host "`n🔐 Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "Device.Read.All","DeviceManagementManagedDevices.Read.All" -NoWelcome

# Fetch Devices
Write-Host "📋 Fetching device inventory from Entra ID..." -ForegroundColor Cyan
$Devices = Get-MgDevice -All -Property DisplayName,OperatingSystem,OperatingSystemVersion,IsCompliant,IsManaged,TrustType,AccountEnabled,ApproximateLastSignInDateTime,DeviceOwnership

Write-Host "   Found $($Devices.Count) device(s)`n" -ForegroundColor Green

# Build Report
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
    $Compliant = if ($Device.IsCompliant -eq $true) { "Compliant" }
                 elseif ($Device.IsCompliant -eq $false) { "Non-Compliant" }
                 else { "Unknown" }
    $LastSeen = if ($Device.ApproximateLastSignInDateTime) {
        $Device.ApproximateLastSignInDateTime.ToString("yyyy-MM-dd")
    } else { "Never" }

    [PSCustomObject]@{
        DeviceName  = $Device.DisplayName
        Ownership   = $Ownership
        TrustType   = $Trust
        OS          = $Device.OperatingSystem
        OSVersion   = $Device.OperatingSystemVersion
        Compliance  = $Compliant
        Managed     = if ($Device.IsManaged) { "Managed" } else { "Unmanaged" }
        Enabled     = if ($Device.AccountEnabled) { "Yes" } else { "No" }
        LastSignIn  = $LastSeen
    }
}

# Summary
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  DEVICE INVENTORY SUMMARY" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Total Devices  : $($Report.Count)"
Write-Host "  Corporate      : $(($Report | Where-Object { $_.Ownership -eq 'Corporate' }).Count)" -ForegroundColor Green
Write-Host "  BYOD/Personal  : $(($Report | Where-Object { $_.Ownership -eq 'BYOD' }).Count)" -ForegroundColor Yellow
Write-Host "  Compliant      : $(($Report | Where-Object { $_.Compliance -eq 'Compliant' }).Count)" -ForegroundColor Green
Write-Host "  Non-Compliant  : $(($Report | Where-Object { $_.Compliance -eq 'Non-Compliant' }).Count)" -ForegroundColor Red
Write-Host "  Unmanaged      : $(($Report | Where-Object { $_.Managed -eq 'Unmanaged' }).Count)" -ForegroundColor Red
Write-Host ""

# Full Table
$Report | Format-Table DeviceName,Ownership,TrustType,OS,Compliance,Managed,LastSignIn -AutoSize

# Export CSV
$Date = Get-Date -Format "yyyy-MM-dd"
$ReportPath = "../../reports/byod-device-inventory-$Date.csv"
$Report | Export-Csv -Path $ReportPath -NoTypeInformation
Write-Host "✅ Report saved to: $ReportPath" -ForegroundColor Green
Write-Host "`nDone!`n" -ForegroundColor Cyan
