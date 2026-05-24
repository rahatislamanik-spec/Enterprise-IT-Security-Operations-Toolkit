# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: User Offboarding Automation
# Author: Md Rahat Islam Anik
# Description: Automates the full M365 user offboarding workflow —
#   disables account, revokes active sessions, removes licenses,
#   clears group memberships, and exports an offboarding evidence report.

param (
    [Parameter(Mandatory = $true)]
    [string]$UserPrincipalName
)

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | USER OFFBOARDING     " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All","GroupMember.ReadWrite.All"

$ReportPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$Log = [System.Collections.Generic.List[string]]::new()

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
    $Log.Add("$(Get-Date -Format 'HH:mm:ss') | $Message")
}

Write-Log "Starting offboarding for: $UserPrincipalName" "Yellow"

try {
    $User = Get-MgUser -UserId $UserPrincipalName -Property Id,DisplayName,UserPrincipalName,AccountEnabled,AssignedLicenses
} catch {
    Write-Log "ERROR: User '$UserPrincipalName' not found. Aborting." "Red"
    exit 1
}

Write-Log "User found: $($User.DisplayName)" "Cyan"

# Step 1 — Disable account
Update-MgUser -UserId $User.Id -AccountEnabled $false
Write-Log "[1/5] Account disabled." "Green"

# Step 2 — Revoke all active sessions
Revoke-MgUserSignInSession -UserId $User.Id | Out-Null
Write-Log "[2/5] All active sign-in sessions revoked." "Green"

# Step 3 — Remove all assigned licenses
if ($User.AssignedLicenses.Count -gt 0) {
    $LicenseIds = $User.AssignedLicenses | Select-Object -ExpandProperty SkuId
    Set-MgUserLicense -UserId $User.Id -AddLicenses @() -RemoveLicenses $LicenseIds | Out-Null
    Write-Log "[3/5] $($LicenseIds.Count) license(s) removed." "Green"
} else {
    Write-Log "[3/5] No licenses assigned — skipping." "Yellow"
}

# Step 4 — Remove all group memberships
$Groups = Get-MgUserMemberOf -UserId $User.Id -All | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.group' }
foreach ($Group in $Groups) {
    try {
        Remove-MgGroupMemberByRef -GroupId $Group.Id -DirectoryObjectId $User.Id -ErrorAction SilentlyContinue
    } catch { continue }
}
Write-Log "[4/5] Removed from $($Groups.Count) group(s)." "Green"

# Step 5 — Export offboarding evidence report
$Report = [PSCustomObject]@{
    OffboardedUser      = $User.UserPrincipalName
    DisplayName         = $User.DisplayName
    OffboardedOn        = Get-Date
    AccountDisabled     = $true
    SessionsRevoked     = $true
    LicensesRemoved     = $User.AssignedLicenses.Count
    GroupsRemoved       = $Groups.Count
}

$CsvFile = "$ReportPath/Offboarding_Report_$($User.UserPrincipalName -replace '@','_at_')_$DateStamp.csv"
$Report | Export-Csv -Path $CsvFile -NoTypeInformation

Write-Log "[5/5] Offboarding report exported: $CsvFile" "Green"

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " OFFBOARDING COMPLETE: $($User.DisplayName)     " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
