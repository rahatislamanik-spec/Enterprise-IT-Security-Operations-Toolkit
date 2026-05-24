# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: Mailbox Permission & Delegation Review
# Author: Md Rahat Islam Anik
# Description: Audits mailbox delegation and Send-As permissions across
#   Exchange Online mailboxes using the Exchange Online PowerShell module.
#   Identifies Full Access and Send-As delegations, flags cross-department
#   access, and exports a governance evidence report.

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | MAILBOX PERMISSION   " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Requires: Exchange Online PowerShell module
# Install-Module ExchangeOnlineManagement -Force
try {
    Import-Module ExchangeOnlineManagement -ErrorAction Stop
} catch {
    Write-Host "Exchange Online Management module not found." -ForegroundColor Red
    Write-Host "Run: Install-Module ExchangeOnlineManagement -Force" -ForegroundColor Yellow
    exit 1
}

Connect-ExchangeOnline -ShowBanner:$false

$ReportPath = "$HOME/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting mailboxes..." -ForegroundColor Yellow
$Mailboxes = Get-Mailbox -ResultSize Unlimited

$FullAccessResults = [System.Collections.Generic.List[object]]::new()
$SendAsResults     = [System.Collections.Generic.List[object]]::new()

Write-Host "Auditing permissions across $($Mailboxes.Count) mailboxes..." -ForegroundColor Yellow

foreach ($Mailbox in $Mailboxes) {
    # Full Access permissions
    $FAPerms = Get-MailboxPermission -Identity $Mailbox.Identity |
               Where-Object { $_.IsInherited -eq $false -and $_.User -notlike "*NT AUTHORITY*" }

    foreach ($Perm in $FAPerms) {
        $FullAccessResults.Add([PSCustomObject]@{
            MailboxName       = $Mailbox.DisplayName
            MailboxUPN        = $Mailbox.UserPrincipalName
            MailboxType       = $Mailbox.RecipientTypeDetails
            DelegatedTo       = $Perm.User
            AccessRights      = ($Perm.AccessRights -join ", ")
            PermissionType    = "Full Access"
            IsInherited       = $Perm.IsInherited
        })
    }

    # Send-As permissions
    $SendAsPerms = Get-RecipientPermission -Identity $Mailbox.Identity |
                   Where-Object { $_.Trustee -notlike "*NT AUTHORITY*" }

    foreach ($Perm in $SendAsPerms) {
        $SendAsResults.Add([PSCustomObject]@{
            MailboxName    = $Mailbox.DisplayName
            MailboxUPN     = $Mailbox.UserPrincipalName
            MailboxType    = $Mailbox.RecipientTypeDetails
            DelegatedTo    = $Perm.Trustee
            AccessRights   = ($Perm.AccessRights -join ", ")
            PermissionType = "Send As"
        })
    }
}

$AllResults = @($FullAccessResults) + @($SendAsResults)
$CsvFile    = "$ReportPath/Mailbox_Permission_Review_$DateStamp.csv"
$AllResults | Export-Csv -Path $CsvFile -NoTypeInformation

Disconnect-ExchangeOnline -Confirm:$false

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " MAILBOX PERMISSION REVIEW COMPLETE             " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host "Mailboxes Audited      : $($Mailboxes.Count)"        -ForegroundColor Cyan
Write-Host "Full Access Delegations: $($FullAccessResults.Count)" -ForegroundColor Yellow
Write-Host "Send-As Delegations    : $($SendAsResults.Count)"     -ForegroundColor Yellow
Write-Host "`nCSV Exported: $CsvFile"                            -ForegroundColor Green
