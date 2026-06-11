# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: User Offboarding Automation
# Author: Md Rahat Islam Anik
# Description: Automates the full M365 user offboarding workflow —
#   disables account, revokes active sessions, removes licenses,
#   clears group memberships, and exports an offboarding evidence report.

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
param (
    [Parameter(Mandatory = $true)]
    [string]$UserPrincipalName
)

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | USER OFFBOARDING     " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All","GroupMember.ReadWrite.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
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
$AccountDisabled = $false
if ($PSCmdlet.ShouldProcess($User.UserPrincipalName, "Disable Microsoft 365 account")) {
    Update-MgUser -UserId $User.Id -AccountEnabled $false
    $AccountDisabled = $true
    Write-Log "[1/5] Account disabled." "Green"
}

# Step 2 — Revoke all active sessions
$SessionsRevoked = $false
if ($PSCmdlet.ShouldProcess($User.UserPrincipalName, "Revoke active sign-in sessions")) {
    Revoke-MgUserSignInSession -UserId $User.Id | Out-Null
    $SessionsRevoked = $true
    Write-Log "[2/5] All active sign-in sessions revoked." "Green"
}

# Step 3 — Remove all assigned licenses
$LicensesRemoved = 0
if ($User.AssignedLicenses.Count -gt 0) {
    $LicenseIds = $User.AssignedLicenses | Select-Object -ExpandProperty SkuId
    if ($PSCmdlet.ShouldProcess($User.UserPrincipalName, "Remove $($LicenseIds.Count) assigned license(s)")) {
        Set-MgUserLicense -UserId $User.Id -AddLicenses @() -RemoveLicenses $LicenseIds | Out-Null
        $LicensesRemoved = $LicenseIds.Count
        Write-Log "[3/5] $LicensesRemoved license(s) removed." "Green"
    }
} else {
    $LicensesRemoved = 0
    Write-Log "[3/5] No licenses assigned — skipping." "Yellow"
}

# Step 4 — Remove all group memberships
$Groups = Get-MgUserMemberOf -UserId $User.Id -All | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.group' }
$GroupsRemoved = 0
foreach ($Group in $Groups) {
    try {
        $GroupDetails = Get-MgGroup -GroupId $Group.Id -Property DisplayName,GroupTypes,IsAssignableToRole
        $IsDynamic = $GroupDetails.GroupTypes -contains "DynamicMembership"
        if ($IsDynamic -or $GroupDetails.IsAssignableToRole) {
            Write-Log "[4/5] Skipped protected or dynamic group: $($GroupDetails.DisplayName)" "Yellow"
            continue
        }
        if ($PSCmdlet.ShouldProcess($GroupDetails.DisplayName, "Remove $($User.UserPrincipalName) from group")) {
            Remove-MgGroupMemberByRef -GroupId $Group.Id -DirectoryObjectId $User.Id -ErrorAction Stop
            $GroupsRemoved++
        }
    } catch { continue }
}
Write-Log "[4/5] Removed from $GroupsRemoved static, non-role-assignable group(s)." "Green"

# Step 5 — Export offboarding evidence report
$Report = [PSCustomObject]@{
    OffboardedUser      = $User.UserPrincipalName
    DisplayName         = $User.DisplayName
    OffboardedOn        = Get-Date
    AccountDisabled     = $AccountDisabled
    SessionsRevoked     = $SessionsRevoked
    LicensesRemoved     = $LicensesRemoved
    GroupsRemoved       = $GroupsRemoved
}

$CsvFile = "$ReportPath/Offboarding_Report_$($User.UserPrincipalName -replace '@','_at_')_$DateStamp.csv"
$Report | Export-Csv -Path $CsvFile -NoTypeInformation

Write-Log "[5/5] Offboarding report exported: $CsvFile" "Green"

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " OFFBOARDING COMPLETE: $($User.DisplayName)     " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
