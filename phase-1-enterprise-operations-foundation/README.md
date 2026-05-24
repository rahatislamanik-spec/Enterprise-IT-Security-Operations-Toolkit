# Phase 1 — Enterprise Operations Foundation

---

## Overview

Phase 1 establishes the centralized operational reporting and governance foundation of the Enterprise IT Security Operations Toolkit.

This phase simulates the day-to-day Microsoft 365 administration and governance workflows performed by Tier 2 and Tier 3 administrators responsible for tenant health, identity hygiene, license management, and compliance reporting at enterprise scale.

All scripts were executed against an isolated Microsoft 365 E3/E5 lab tenant. Real output reports and screenshots are included as operational evidence.

---

## Operational Problem Statement

Enterprise M365 administrators routinely face:

- **No unified tenant health view** — critical metrics spread across multiple admin portals
- **Manual audit overhead** — MFA compliance, admin role reviews, and CA audits done by hand
- **License waste** — disabled accounts retaining paid licenses, unlicensed active users
- **Privileged access drift** — admin roles unreviewed, disabled accounts holding critical roles
- **Reactive governance** — no automated flagging for inactive users or risky access patterns

This phase addresses all of the above through PowerShell automation and centralized reporting.

---

## Implemented Solution

A suite of PowerShell scripts built on the **Microsoft Graph PowerShell SDK** that pull tenant-wide operational data, apply governance logic, and export structured CSV and TXT reports — reducing hours of manual portal work to minutes.

---

## Architecture

```text
Microsoft 365 / Entra ID Tenant
            ↓
Microsoft Graph PowerShell SDK
            ↓
PowerShell Automation Scripts
            ↓
Governance & Risk Logic (flagging, classification)
            ↓
CSV / TXT Operational Reports
            ↓
HTML Dashboard Visualization
            ↓
GitHub Evidence & Reporting Platform
```

---

## Script Inventory

### `scripts/m365-reports/` — Core Reporting Modules

| Script | Purpose | Key Output |
|---|---|---|
| `tenant-health.ps1` | Full tenant snapshot: users, groups, licenses, roles | CSV + TXT report |
| `mfa-coverage.ps1` | MFA registration status across all users | CSV with per-user MFA state |
| `admin-role-audit.ps1` | All active directory role assignments | CSV with role + user mapping |
| `conditional-access-audit.ps1` | CA policy inventory and state audit | CSV with policy states |
| `device-compliance.ps1` | Entra ID registered device inventory | CSV with device + trust type |
| `inactive-user-governance.ps1` | Users inactive >30 days, licensed-but-disabled accounts | CSV with risk flags |
| `license-optimization.ps1` | License waste analysis across tenant | CSV with optimization flags |
| `privileged-user-exposure.ps1` | Privileged accounts with CRITICAL/HIGH risk tier | CSV with risk classification |
| `signin-security.ps1` | Sign-in log analysis — success/failure breakdown | CSV with location + IP data |

### `scripts/m365-admin-toolkit/` — Operational Administration Toolkit

| Script | Purpose |
|---|---|
| `01-user-offboarding.ps1` | Full offboarding: disable, revoke sessions, remove licenses + groups |
| `02-inactive-user-report.ps1` | Configurable-threshold inactivity audit with risk flagging |
| `03-license-report.ps1` | SKU-level utilization summary + per-user optimization report |
| `04-admin-role-review.ps1` | Role review with CRITICAL/HIGH/MEDIUM/STANDARD risk tier classification |
| `05-pim-activation-alerts.ps1` | PIM role activation audit from Entra ID audit log |
| `06-mfa-enforcement-check.ps1` | MFA method-level audit (Authenticator, Phone, FIDO2, Passwordless) |
| `07-external-sharing-audit.ps1` | Guest user governance — domain mapping, inactivity flags |
| `08-mailbox-permission-review.ps1` | Exchange Online Full Access + Send-As delegation audit |
| `09-conditional-access-report.ps1` | CA policy state + coverage gap analysis |
| `10-security-group-drift-check.ps1` | Group membership health — empty groups, disabled members, nested groups |

---

## Lab Evidence

The following real outputs from the lab tenant are included in `sample-reports/m365/`:

| Report File | Key Finding |
|---|---|
| `TenantHealthReport_2026-05-23.csv` | 28 total users, 27 enabled, 21 licensed, 11 active directory roles |
| `MFA_Coverage_Report_2026-05-23.csv` | Per-user MFA state across all accounts |
| `Admin_Role_Audit_Report_2026-05-23.csv` | Full privileged role assignment inventory |
| `Conditional_Access_Audit_2026-05-24.csv` | All CA policies with state classification |
| `Device_Compliance_Report_2026-05-23.csv` | Enrolled device inventory with trust type |
| `License_Optimization_Report_2026-05-23.csv` | License waste and optimization flags |
| `Privileged_User_Exposure_Audit_2026-05-24.csv` | CRITICAL and HIGH risk role holders |
| `Inactive_User_Governance_Report_2026-05-24.csv` | Inactive and licensed-but-disabled accounts |

---

## Prerequisites

- PowerShell 7+
- Microsoft Graph PowerShell SDK: `Install-Module Microsoft.Graph -Force`
- Exchange Online Management (script 08 only): `Install-Module ExchangeOnlineManagement -Force`
- Microsoft 365 tenant with appropriate admin permissions
- Entra ID P2 licensing required for PIM activation audits

---

## How to Run

```powershell
# Clone the repository
git clone https://github.com/rahatislamanik-spec/Enterprise-IT-Security-Operations-Toolkit.git
cd Enterprise-IT-Security-Operations-Toolkit

# Run any Phase 1 reporting script
./scripts/m365-reports/tenant-health.ps1

# Run an admin toolkit script
./scripts/m365-admin-toolkit/06-mfa-enforcement-check.ps1

# Offboarding requires the UPN parameter
./scripts/m365-admin-toolkit/01-user-offboarding.ps1 -UserPrincipalName "user@domain.com"
```

Reports export to:
`~/Documents/Enterprise-IT-Security-Operations-Toolkit/phase-1-enterprise-operations-foundation/reports/`

---

## Business & Operational Impact

| Manual Process | Before Automation | After Automation |
|---|---|---|
| Full tenant health audit | ~2–3 hours across portals | Under 3 minutes |
| MFA compliance review (28 users) | Manual per-user portal checks | Single script run |
| Admin role inventory | Manual portal navigation | Automated CSV with risk tiers |
| License waste identification | No systematic process | Automated flagging per run |
| CA policy state audit | Manual policy-by-policy review | Full inventory in one export |
