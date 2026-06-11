# =============================================================
#  exchange-mail-flow-audit.ps1
#  Phase 5 — Exchange Online Mail Flow Audit
#  Enterprise-IT-Security-Operations-Toolkit
#  Author: Md Rahat Islam Anik
#  Description: Audits Exchange Online mail flow security —
#  external forwarding rules, transport rules, mailbox
#  forwarding, spam policies, and litigation hold status.
# =============================================================

# Connect
Write-Host "`n🔐 Connecting to Exchange Online..." -ForegroundColor Cyan
Connect-ExchangeOnline -Device -ShowBanner:$false

$Date = Get-Date -Format "yyyy-MM-dd"
$ReportPath = Join-Path $PSScriptRoot "../reports"

# ── 1. Mailbox Forwarding Audit ──────────────────────────────
Write-Host "`n📋 Checking mailbox forwarding rules..." -ForegroundColor Cyan
$Mailboxes = Get-Mailbox -ResultSize Unlimited
$ForwardingReport = foreach ($MB in $Mailboxes) {
    $HasForwarding = $false
    $ForwardTo = "None"
    if ($MB.ForwardingAddress -or $MB.ForwardingSmtpAddress) {
        $HasForwarding = $true
        $ForwardTo = if ($MB.ForwardingSmtpAddress) { $MB.ForwardingSmtpAddress } else { $MB.ForwardingAddress }
    }
    [PSCustomObject]@{
        Mailbox          = $MB.DisplayName
        UPN              = $MB.UserPrincipalName
        MailboxType      = $MB.RecipientTypeDetails
        HasForwarding    = $HasForwarding
        ForwardTo        = $ForwardTo
        DeliverAndForward = $MB.DeliverToMailboxAndForward
        LitigationHold   = $MB.LitigationHoldEnabled
        HoldDate         = if ($MB.LitigationHoldDate) { $MB.LitigationHoldDate.ToString("yyyy-MM-dd") } else { "N/A" }
    }
}

$ForwardingMailboxes = $ForwardingReport | Where-Object { $_.HasForwarding -eq $true }
Write-Host "   Total mailboxes: $($ForwardingReport.Count)" -ForegroundColor Green
Write-Host "   Mailboxes with forwarding: $($ForwardingMailboxes.Count)" -ForegroundColor $(if ($ForwardingMailboxes.Count -gt 0) { "Red" } else { "Green" })

# ── 2. Inbox Rules with External Forwarding ──────────────────
Write-Host "`n📋 Checking inbox rules for external forwarding..." -ForegroundColor Cyan
$InboxRuleReport = @()
foreach ($MB in $Mailboxes) {
    try {
        $Rules = Get-InboxRule -Mailbox $MB.UserPrincipalName -ErrorAction SilentlyContinue
        foreach ($Rule in $Rules) {
            if ($Rule.ForwardTo -or $Rule.ForwardAsAttachmentTo -or $Rule.RedirectTo) {
                $InboxRuleReport += [PSCustomObject]@{
                    Mailbox     = $MB.DisplayName
                    UPN         = $MB.UserPrincipalName
                    RuleName    = $Rule.Name
                    Enabled     = $Rule.Enabled
                    ForwardTo   = ($Rule.ForwardTo -join "; ")
                    RedirectTo  = ($Rule.RedirectTo -join "; ")
                    Priority    = $Rule.Priority
                }
            }
        }
    } catch {}
}
Write-Host "   Inbox rules with forwarding/redirect: $($InboxRuleReport.Count)" -ForegroundColor $(if ($InboxRuleReport.Count -gt 0) { "Red" } else { "Green" })

# ── 3. Transport Rules Audit ─────────────────────────────────
Write-Host "`n📋 Auditing transport rules..." -ForegroundColor Cyan
$TransportRules = Get-TransportRule
$TransportReport = foreach ($Rule in $TransportRules) {
    [PSCustomObject]@{
        RuleName    = $Rule.Name
        State       = $Rule.State
        Priority    = $Rule.Priority
        Description = $Rule.Description
        Actions     = ($Rule.Actions -join "; ")
        Conditions  = ($Rule.Conditions -join "; ")
    }
}
Write-Host "   Transport rules found: $($TransportReport.Count)" -ForegroundColor Green

# ── 4. Anti-Spam Policy Audit ────────────────────────────────
Write-Host "`n📋 Auditing anti-spam policies..." -ForegroundColor Cyan
$SpamPolicies = Get-HostedContentFilterPolicy
$SpamReport = foreach ($Policy in $SpamPolicies) {
    [PSCustomObject]@{
        PolicyName          = $Policy.Name
        IsDefault           = $Policy.IsDefault
        SpamAction          = $Policy.SpamAction
        HighConfidenceSpam  = $Policy.HighConfidenceSpamAction
        PhishAction         = $Policy.PhishSpamAction
        BulkThreshold       = $Policy.BulkThreshold
        QuarantineRetention = $Policy.QuarantineRetentionPeriod
    }
}
Write-Host "   Anti-spam policies: $($SpamReport.Count)" -ForegroundColor Green

# ── 5. Litigation Hold Summary ───────────────────────────────
$OnHold = $ForwardingReport | Where-Object { $_.LitigationHold -eq $true }
Write-Host "`n📋 Litigation hold summary..." -ForegroundColor Cyan
Write-Host "   Mailboxes on litigation hold: $($OnHold.Count)" -ForegroundColor $(if ($OnHold.Count -gt 0) { "Cyan" } else { "Yellow" })

# ── Summary Display ──────────────────────────────────────────
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  EXCHANGE ONLINE MAIL FLOW AUDIT SUMMARY" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Total Mailboxes          : $($ForwardingReport.Count)"
Write-Host "  Mailboxes with Forwarding: $($ForwardingMailboxes.Count)" -ForegroundColor $(if ($ForwardingMailboxes.Count -gt 0) { "Red" } else { "Green" })
Write-Host "  Inbox Forwarding Rules   : $($InboxRuleReport.Count)" -ForegroundColor $(if ($InboxRuleReport.Count -gt 0) { "Red" } else { "Green" })
Write-Host "  Transport Rules          : $($TransportReport.Count)"
Write-Host "  Anti-Spam Policies       : $($SpamReport.Count)"
Write-Host "  On Litigation Hold       : $($OnHold.Count)"
Write-Host ""

# ── Export CSV Reports ───────────────────────────────────────
$ForwardingReport  | Export-Csv "$ReportPath/mailbox-forwarding-audit-$Date.csv" -NoTypeInformation
$InboxRuleReport   | Export-Csv "$ReportPath/inbox-forwarding-rules-$Date.csv" -NoTypeInformation
$TransportReport   | Export-Csv "$ReportPath/transport-rules-audit-$Date.csv" -NoTypeInformation
$SpamReport        | Export-Csv "$ReportPath/antispam-policy-audit-$Date.csv" -NoTypeInformation

Write-Host "✅ Reports saved to: $ReportPath" -ForegroundColor Green
Write-Host "`nDone!`n" -ForegroundColor Cyan
