# M365 Admin Toolkit — Operational Administration Scripts

This folder contains 10 production-grade PowerShell scripts for day-to-day Microsoft 365 administration, identity governance, and security operations workflows.

These scripts complement the `m365-reports/` core reporting modules and focus on **actionable operational tasks** rather than read-only reporting — including user offboarding automation, PIM auditing, mailbox delegation reviews, and group drift detection.

---

## Prerequisites

- PowerShell 7+
- Microsoft Graph PowerShell SDK: `Install-Module Microsoft.Graph -Force`
- Exchange Online Management (for script 08): `Install-Module ExchangeOnlineManagement -Force`
- Microsoft 365 admin account with appropriate role assignments
- Entra ID P2 licensing for scripts 05 (PIM) and related Identity Protection features

---

## Script Reference

| # | Script | Scope | Key Graph Scopes Required |
|---|---|---|---|
| 01 | `01-user-offboarding.ps1` | Disable, session revoke, license removal, group cleanup | `User.ReadWrite.All`, `GroupMember.ReadWrite.All` |
| 02 | `02-inactive-user-report.ps1` | Inactivity audit with configurable threshold | `User.Read.All`, `AuditLog.Read.All` |
| 03 | `03-license-report.ps1` | SKU utilization + per-user optimization flags | `User.Read.All`, `Organization.Read.All` |
| 04 | `04-admin-role-review.ps1` | Role assignment review with CRITICAL/HIGH/MEDIUM risk tiers | `RoleManagement.Read.Directory` |
| 05 | `05-pim-activation-alerts.ps1` | PIM activation events from Entra audit log | `AuditLog.Read.All` |
| 06 | `06-mfa-enforcement-check.ps1` | Per-user MFA method audit (Authenticator, Phone, FIDO2) | `UserAuthenticationMethod.Read.All` |
| 07 | `07-external-sharing-audit.ps1` | Guest user governance — domain mapping, inactivity detection | `User.Read.All`, `AuditLog.Read.All` |
| 08 | `08-mailbox-permission-review.ps1` | Exchange Online Full Access + Send-As delegation audit | Exchange Online module |
| 09 | `09-conditional-access-report.ps1` | CA policy state + report-only / disabled policy flagging | `Policy.Read.All` |
| 10 | `10-security-group-drift-check.ps1` | Group health — empty groups, disabled members, nested groups | `Group.Read.All`, `User.Read.All` |

---

## Usage Examples

```powershell
# Full user offboarding (requires UPN)
./01-user-offboarding.ps1 -UserPrincipalName "john.smith@contoso.com"

# Inactive users — custom threshold (default: 30 days)
./02-inactive-user-report.ps1 -InactiveDaysThreshold 60

# PIM activation audit — custom lookback window (default: 7 days)
./05-pim-activation-alerts.ps1 -LookbackDays 14

# All other scripts run with no parameters
./06-mfa-enforcement-check.ps1
```

---

## Output Location

All reports export to:

```
~/Documents/Enterprise-IT-Security-Operations-Toolkit/
  phase-1-enterprise-operations-foundation/
    reports/
```

---

## Governance Coverage Map

```text
Identity Hygiene      → Scripts 02, 07
License Management    → Scripts 02, 03
Privileged Access     → Scripts 04, 05
MFA & Authentication  → Script 06
Mailbox Security      → Script 08
Network / CA Policy   → Script 09
Group Governance      → Script 10
Offboarding Workflow  → Script 01
```
