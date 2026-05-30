# Enterprise IT Security Operations Toolkit

Enterprise-grade Microsoft 365 security operations and governance platform built with PowerShell, Microsoft Graph, Entra ID, Intune, Microsoft Defender, and HTML dashboards.

**19 PowerShell scripts. 3 operational phases. Real lab evidence. End-to-end enterprise security simulation.**

---

## Platform Overview

The Enterprise IT Security Operations Toolkit is a multi-phase, hands-on security operations and governance platform built to simulate real-world Microsoft 365 administration — from tenant health baselines through identity threat visibility to endpoint security operations.

The platform was developed in an isolated Microsoft 365 E3/E5 lab environment and includes **real executed scripts, real CSV output reports, and operational screenshots** as evidence of live implementation.

---

## What This Platform Does

| Capability | Detail |
|---|---|
| Tenant Governance | Automated health, user, group, license, and role reporting |
| MFA Compliance | Per-user MFA method audit with passwordless-readiness tracking |
| Privileged Access | Admin role inventory with CRITICAL / HIGH / MEDIUM risk tier classification |
| Identity Threat | Risky user auditing, risk detection reporting, Secure Score tracking |
| License Optimization | Waste detection — disabled users with licenses, unlicensed active members |
| Endpoint Security | Intune device governance, Defender visibility, compliance posture |
| CA Policy Governance | Policy state audit — enforced vs. report-only vs. disabled |
| Offboarding Automation | Disable + session revoke + license removal + group cleanup in one script |
| PIM Auditing | Privileged Identity Management activation event tracking |
| External Access | Guest user governance with domain mapping and inactivity detection |

**Before this toolkit:** A full MFA compliance review, admin role audit, and CA policy inventory required 2–3 hours of manual navigation across the Microsoft 365 Admin Center, Entra ID portal, and Intune portal.

**After:** Each report runs in under 3 minutes. All outputs are structured CSVs ready for governance review or executive reporting.

---

## Real Lab Results

From the M365 E3/E5 lab environment:

| Metric | Value |
|---|---|
| Total users audited | 28 |
| Enabled accounts | 27 |
| Licensed accounts | 21 |
| Active directory roles | 11 |
| Microsoft Secure Score | 146.26 / 204 |
| Groups audited | 10 (7 security, 3 mail-enabled, 4 dynamic) |
| Report types generated | 11 unique report files across 3 phases |
| Scripts in platform | 19 PowerShell scripts |

---

## Multi-Phase Platform Architecture

### Phase 1 — Enterprise Operations Foundation

**Focus:** Baseline tenant health, identity hygiene, license governance, MFA compliance, CA auditing, privileged access reviews, and administrative reporting.

**Scripts:** 9 reporting modules + 10 admin toolkit scripts = **19 total scripts**

**Highlights:**
- Full tenant health snapshot (users, groups, licenses, roles) in a single script
- MFA method-level audit — Authenticator, Phone, FIDO2, Passwordless-ready classification
- Admin role review with CRITICAL/HIGH/MEDIUM/STANDARD risk tier classification
- License waste identification — disabled users holding licenses flagged automatically
- User offboarding automation — disable, revoke sessions, remove licenses and groups

[→ Phase 1 README](phase-1-enterprise-operations-foundation/README.md)

---

### Phase 2 — Identity Threat & Security Operations

**Focus:** Microsoft Entra ID Identity Protection workflows — risky users, risk detections, Secure Score analysis, and guest user governance.

**Highlights:**
- Risky user audit — High / Medium / Low risk classification with state tracking
- Risk detection reporting — impossible travel, anonymous IP, malware-linked sign-ins
- Secure Score analysis — lab tenant scored **146.26 / 204**
- Guest user governance — inactive guest detection with external domain mapping

[→ Phase 2 README](phase-2-identity-threat-security-operations/README.md)

---

### Phase 3 — Endpoint Security & Defender Operations

**Focus:** Microsoft Intune device governance, Microsoft Defender for Endpoint visibility, endpoint compliance monitoring, and security posture reporting.

**Highlights:**
- Defender Endpoint Overview — device risk and protection status
- Intune device inventory and compliance posture reporting
- Endpoint compliance dashboards and security baseline verification
- Defender security recommendations and incident visibility workflows

[→ Phase 3 README](phase-3-endpoint-security-defender-operations/README.md)

---

## Platform Architecture

```text
Enterprise Environment (M365 E3/E5 Lab)
                    ↓
Microsoft 365 / Entra ID / Intune / Defender
                    ↓
        Microsoft Graph + Security APIs
                    ↓
       PowerShell Automation Layer (19 scripts)
                    ↓
  Governance & Risk Classification Logic
     ↙                                    ↘
Identity + Endpoint               License + Access
Security Operations               Governance Reporting
     ↓                                    ↓
CSV / TXT Reports         HTML Dashboards & Visualization
                    ↓
      GitHub Security Operations Platform
```

---

## Repository Structure

```text
Enterprise-IT-Security-Operations-Toolkit/
│
├── phase-1-enterprise-operations-foundation/
│   └── README.md
│
├── phase-2-identity-threat-security-operations/
│   ├── reports/
│   ├── screenshots/
│   ├── scripts/
│   └── README.md
│
├── phase-3-endpoint-security-defender-operations/
│   ├── screenshots/
│   └── README.md
│
├── scripts/
│   ├── m365-reports/          ← 9 core reporting scripts
│   └── m365-admin-toolkit/    ← 10 operational admin scripts
│
├── sample-reports/
│   └── m365/                  ← Real CSV outputs from lab
│
├── screenshots/               ← Phase 1 operational evidence
├── dashboard/                 ← HTML dashboard assets
├── index.html                 ← Interactive security operations dashboard
└── LICENSE
```

---

## Prerequisites

| Requirement | Details |
|---|---|
| PowerShell | Version 7+ |
| Microsoft Graph SDK | `Install-Module Microsoft.Graph -Force` |
| Exchange Online | `Install-Module ExchangeOnlineManagement -Force` (script 08 only) |
| M365 Tenant | Admin account with appropriate role assignments |
| Entra ID P2 | Required for PIM activation audits and Identity Protection scripts |

---

## Quick Start

```powershell
# Clone the repository
git clone https://github.com/rahatislamanik-spec/Enterprise-IT-Security-Operations-Toolkit.git
cd Enterprise-IT-Security-Operations-Toolkit

# Phase 1 — Run a tenant health report
./scripts/m365-reports/tenant-health.ps1

# Phase 1 — MFA compliance check
./scripts/m365-admin-toolkit/06-mfa-enforcement-check.ps1

# Phase 1 — Offboard a user
./scripts/m365-admin-toolkit/01-user-offboarding.ps1 -UserPrincipalName "user@domain.com"

# Phase 2 — Identity risk audit
./phase-2-identity-threat-security-operations/scripts/risky-user-audit.ps1

# Phase 2 — Secure Score report
./phase-2-identity-threat-security-operations/scripts/secure-score-report.ps1
```

All reports export to:
`~/Documents/Enterprise-IT-Security-Operations-Toolkit/`

---

## Core Technologies

PowerShell 7 · Microsoft Graph PowerShell SDK · Microsoft 365 · Microsoft Entra ID · Microsoft Intune · Microsoft Defender for Endpoint · Exchange Online PowerShell · Conditional Access · Identity Protection · HTML / CSS / JavaScript · GitHub

---

## Lab Environment Disclaimer

This platform was developed in isolated Microsoft 365 E3 and E5 lab tenants created exclusively for security operations simulation, governance workflow testing, automation engineering, and portfolio demonstration.

No production organizational infrastructure, customer data, confidential business information, or real enterprise tenant data is exposed within this repository.

---

## Platform Roadmap

Near-term planned additions:

1. **GitHub Actions** — automated scheduled reporting pipeline
2. **Power BI integration** — executive KPI dashboard layer over CSV outputs
3. **Threat hunting workflows** — Defender Advanced Hunting queries (KQL)
4. **Automated investigation playbooks** — scripted response for common alert types
5. **Secure Score trend tracking** — longitudinal score history and improvement analysis

---

## Author

**Md Rahat Islam Anik**
Cloud Computing & Network Administration, George Brown College
[linkedin.com/in/rahatislamanik](https://linkedin.com/in/rahatislamanik) · [github.com/rahatislamanik-spec](https://github.com/rahatislamanik-spec)

---

### Phase 4 — BYOD Conditional Access Governance

**Focus:** Zero Trust device governance — enforcing compliant device requirements for BYOD and personal devices accessing Microsoft 365 resources via Conditional Access.

**Highlights:**

- BYOD device inventory — classifies all Entra ID devices by ownership, trust type, and compliance state
- Conditional Access policy audit — identifies policies requiring compliant devices, targeting BYOD, or blocking unmanaged devices
- Compliant device access audit — cross-references device compliance with CA policy impact per device
- Three tiered Intune compliance policies: iOS BYOD, Windows Standard, Windows Faculty/Staff
- Non-compliant device retirement workflow demonstrated via Intune Device Actions

[→ Phase 4 README](https://github.com/rahatislamanik-spec/Enterprise-IT-Security-Operations-Toolkit/blob/main/phase-4-byod-conditional-access-governance/README.md)

---

## 🌐 Portfolio Ecosystem

This project is part of a 4-repo enterprise IT portfolio covering the full IT lifecycle.

| Layer | Project | Focus |
|---|---|---|
| 01 — Network Foundation | [Enterprise IT Network Diagnostics Toolkit](https://github.com/rahatislamanik-spec/Enterprise-IT-Network-Diagnostics-Toolkit) | DNS · Connectivity · Network Diagnostics |
| 02 — User Lifecycle | [Project Arabesque](https://github.com/rahatislamanik-spec/Project-Arabesque) | Onboarding · Offboarding · M365 Automation |
| 03 — Identity & Security | **You are here** | Entra ID · Intune · Defender · Zero Trust |
| 04 — M365 Operations | [Meridian Institute M365 Lab](https://github.com/rahatislamanik-spec/Meridian-Institute-M365-Lab) | Exchange · Teams · SharePoint · Purview |

👉 [View Full Portfolio](https://rahatislamanik-spec.github.io/IT-Portfolio-Rahat-Islam-Anik/)
