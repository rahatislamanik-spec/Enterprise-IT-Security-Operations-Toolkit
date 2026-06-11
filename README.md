# Enterprise IT Security Operations Toolkit

Microsoft 365 security operations lab and governance toolkit built with PowerShell, Microsoft Graph, Entra ID, Intune, Microsoft Defender, and Exchange Online.

**30+ PowerShell scripts. 9 operational phases. Executed lab evidence. Microsoft 365 security and compliance operations simulation.**

🌐 **[View Live Portfolio Site](https://rahatislamanik-spec.github.io/Enterprise-IT-Security-Operations-Toolkit/)**

---

## Portfolio Case Summary

| STAR element | Summary |
|---|---|
| Situation | Microsoft 365 administrators often need to review tenant health, identity exposure, endpoint posture, mail flow security, app permissions, and investigation evidence across several portals. |
| Task | Build a repeatable lab toolkit that collects security and governance evidence with PowerShell instead of relying only on manual portal review. |
| Action | Implemented Microsoft Graph, Exchange Online, Entra ID, Intune, Defender, Conditional Access, Purview, and reporting workflows across 9 operational phases. |
| Result | Produced scripts, CSV/TXT reports, screenshots, and dashboard views that demonstrate Microsoft 365 administration, security review, and incident triage readiness. |

---

## Toolkit Overview

The Enterprise IT Security Operations Toolkit is a multi-phase, hands-on Microsoft 365 security operations and governance lab built to simulate real-world administration workflows — from tenant health baselines through identity threat visibility, endpoint security, BYOD governance, mail flow auditing, web-only access configuration, app registration auditing, incident response triage, and Microsoft Purview data protection.

Built in isolated Microsoft 365 E3/E5 lab environments with **executed scripts, CSV/TXT output reports, and operational screenshots** as evidence of implementation.

---

## What This Proves for Hiring Managers

| Target skill | Evidence in this repo |
|---|---|
| Microsoft 365 administration | Tenant health, users, groups, licenses, roles, Exchange Online, and report generation |
| Entra ID / identity governance | MFA method review, risky users, guest users, admin roles, PIM-related review, OAuth grants |
| Conditional Access | Policy inventory, report-only validation, compliant-device requirements, web-only access controls |
| Intune / endpoint administration | Company Portal enrollment, managed-device inventory, ownership, and compliance-state evidence |
| PowerShell automation | 30+ scripts using Microsoft Graph and Exchange Online modules |
| Security operations | Secure Score tracking, high-risk permission review, sign-in evidence, and initial triage package |
| Microsoft Purview | DLP design and simulation, Compliance Manager review, Insider Risk policy planning, sensitivity labels, and retention labels |
| Documentation discipline | Phase READMEs, screenshots, sample reports, GitHub Pages site, and evidence map |

For a quick evidence review, start with [`docs/evidence-map.md`](docs/evidence-map.md).

---

## What This Platform Does

| Capability | Detail |
|---|---|
| Tenant Governance | Automated health, user, group, license, and role reporting |
| MFA Compliance | Per-user MFA method audit with passwordless-readiness tracking |
| Privileged Access | Admin role inventory with CRITICAL / HIGH / MEDIUM risk tier classification |
| Identity Threat | Identity Protection audit workflows, Secure Score tracking, and explicit zero-result evidence handling |
| License Optimization | Waste detection — disabled users with licenses, unlicensed active members |
| Endpoint Operations | Intune enrollment, managed-device visibility, ownership, and compliance posture |
| CA Policy Governance | Policy state audit — enabled vs. report-only vs. disabled |
| BYOD Governance | Zero Trust device access controls via Conditional Access |
| Mail Flow Security | External forwarding, inbox rules, transport rules, anti-spam audit |
| Web-Only Access | App-enforced restrictions configured for unmanaged-device scenarios |
| App Registration Audit | OAuth grants, service principals, high-risk permission detection |
| Initial Security Triage | Early evidence collection — users, licenses, groups, and admin roles for escalation |
| Data Protection | Purview DLP, Compliance Manager, Insider Risk Management, sensitivity labels, and retention controls |
| Offboarding Automation | Disable + session revoke + license removal + group cleanup |

---

## Real Lab Results

| Metric | Value |
|---|---|
| Total users audited | 28 |
| Enabled accounts | 27 |
| Licensed accounts | 21 |
| Active directory roles | 11 |
| Microsoft Secure Score | 146.26 / 204 (71.7%) retained snapshot |
| Groups audited | 10 |
| App registrations audited | 1 (AWS Single-Account Access) |
| Service principals inventoried | 241 |
| High-risk OAuth grants detected | 3 |
| Mailboxes audited | 23 |
| Report types generated | 25+ unique report files across the PowerShell-based phases |
| Scripts in toolkit | 30+ PowerShell scripts |

---

## Multi-Phase Platform Architecture

### Phase 1 — Enterprise Operations Foundation

**Focus:** Baseline tenant health, identity hygiene, license governance, MFA compliance, CA auditing, privileged access reviews, and administrative reporting.

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
- Identity Protection scripts prepared for risky-user and risk-detection review
- Zero-result risk and guest queries documented honestly; empty exports were not retained
- Secure Score analysis — retained lab snapshot scored **146.26 / 204 (71.7%)**
- Guest user governance — inactive guest detection with external domain mapping

[→ Phase 2 README](phase-2-identity-threat-security-operations/README.md)

---

### Phase 3 — Endpoint Enrollment & Intune Operations

**Focus:** Microsoft Intune macOS enrollment, Company Portal workflow, managed-device visibility, ownership, and compliance-state review.

**Highlights:**
- Company Portal management-profile installation workflow
- Intune managed-device inventory with platform, ownership, and compliance state
- Company Portal device-status review
- Unsupported Defender incident and recommendation claims explicitly removed

[→ Phase 3 README](phase-3-endpoint-security-defender-operations/README.md)

---

### Phase 4 — BYOD Conditional Access Governance

**Focus:** Zero Trust device governance — configured and audited compliant-device requirements for BYOD and personal devices accessing Microsoft 365 resources via Conditional Access.

**Highlights:**
- BYOD device inventory — classifies all Entra ID devices by ownership, trust type, and compliance state
- Conditional Access policy audit — identifies policies requiring compliant devices
- Three tiered Intune compliance policies: iOS BYOD, Windows Standard, Windows Faculty/Staff
- Report-only compliant-device access design documented with Intune policy evidence

[→ Phase 4 README](phase-4-byod-conditional-access-governance/README.md)

---

### Phase 5 — Exchange Online Mail Flow Audit

**Focus:** Automated audit of Exchange Online mail flow security — external forwarding rules, inbox rules, transport rules, anti-spam policies, and litigation hold status.

**Highlights:**
- 23 mailboxes audited for unauthorized external forwarding — none detected
- Inbox rules scanned for forwarding/redirect actions
- Transport rule inventory with state and action documentation
- Anti-spam policy coverage verified across inbound, outbound, and connection filtering
- 3 non-empty CSV reports retained from PowerShell and Exchange Online Management workflows

[→ Phase 5 README](phase-5-exchange-online-mail-flow-audit/README.md)

---

### Phase 6 — Web-Only Access Governance for Unmanaged Devices

**Focus:** Zero Trust web-only access configuration — Conditional Access app-enforced restrictions limiting non-compliant BYOD devices to browser-only access for SharePoint Online and Exchange Online.

**Highlights:**
- CA policy targeting non-compliant devices with device filter rule
- App-enforced restrictions session control — browser-only, no native apps, no downloads
- PowerShell audit script detects and classifies web-only governance policies
- Before/after audit evidence showing 0 → 1 web-only policy detection

[→ Phase 6 README](phase-6-web-only-access-governance/README.md)

---

### Phase 7 — Entra ID App Registration Audit

**Focus:** Automated audit of all Entra ID app registrations, OAuth permission grants, service principals, credential expiry, and high-risk permission assignments.

**Highlights:**
- 1 app registration audited — AWS Single-Account Access (SAML SSO integration)
- 241 service principals inventoried across Microsoft first-party and third-party apps
- 8 OAuth grants reviewed — full delegated permission inventory
- 3 high-risk permission grants detected — User.ReadWrite.All, Directory.ReadWrite.All, AuditLog.Read.All
- 0 expired credentials — no abandoned app registrations
- 4 CSV reports exported via PowerShell and Microsoft Graph

[→ Phase 7 README](phase-7-entra-app-registration-audit/README.md)

---

### Phase 8 — M365 Initial Security Triage

**Focus:** Early Microsoft 365 evidence collection — user enumeration, license governance, security group review, and administrative role exposure assessment.

**Business Scenario:** A user reports suspicious activity on their account. The administrator uses Microsoft Graph PowerShell to collect early-stage evidence before escalation to a formal response process.

**Highlights:**
- 25 user accounts enumerated with account status and identity details
- 3 license SKUs reviewed — consumption and capability status documented
- 10 security groups inventoried — membership and security enablement verified
- 11 administrative roles identified — exposure assessment for incident triage
- Executive summary report generated for escalation documentation
- 5 structured reports exported via PowerShell and Microsoft Graph

[→ Phase 8 README](phase-8-m365-incident-response-security-triage/README.md)

---

### Phase 9 — Data Protection & Compliance Operations

**Focus:** Microsoft Purview policy design and governance review across DLP, Compliance Manager, Insider Risk Management, sensitivity labels, and retention labels.

**Highlights:**
- DLP policy scope documented across Exchange, SharePoint, OneDrive, and Teams
- Sensitive information conditions, alert behavior, user notifications, and overrides reviewed
- DLP policy retained in simulation mode for staged validation
- Compliance Manager assessments, score snapshot, and improvement actions documented
- Insider Risk Management policy design and policy-health evidence captured
- Sensitivity-label hierarchy, publishing policy, adaptive scope, and simulation-mode auto-labeling workflow documented
- Seven-year retention-label configuration reviewed

[→ Phase 9 README](phase-9-data-protection-compliance-operations/README.md)

---

## Key Design Decisions & Lessons Learned

- **Stage before enforcing:** Conditional Access and DLP controls were reviewed in report-only or simulation modes where supported to reduce rollout risk.
- **Separate inventory from compliance:** Entra device registration is not the same as Intune managed-device compliance; the reporting script now queries Intune managed devices directly.
- **Treat registration as evidence, not enforcement:** Registered MFA methods indicate authentication readiness, but do not by themselves prove that a Conditional Access policy enforced MFA for every sign-in.
- **Preserve evidence limits:** A Compliance Manager score, healthy policy status, or empty alert list is a point-in-time posture signal, not proof of regulatory compliance or incident-free operations.
- **Design destructive automation carefully:** Offboarding actions now support `-WhatIf`, confirmation, and protected-group safeguards before tenant changes occur.

---

## Platform Architecture

```
Enterprise Environment (M365 E3/E5 Lab)
                    ↓
Microsoft 365 / Entra ID / Intune / Microsoft Defender / Exchange Online / Purview
                    ↓
        Microsoft Graph + Security APIs
                    ↓
       PowerShell Automation Layer (30+ scripts)
                    ↓
  Governance & Risk Classification Logic
     ↙                                    ↘
Identity + Endpoint               License + Access
Security Operations               Governance Reporting
     ↓                                    ↓
CSV / TXT Reports         HTML Dashboards & Visualization
                    ↓
      GitHub Security Operations Lab Evidence
```

---

## Repository Structure

```
Enterprise-IT-Security-Operations-Toolkit/
│
├── phase-1-enterprise-operations-foundation/
├── phase-2-identity-threat-security-operations/
├── phase-3-endpoint-security-defender-operations/
├── phase-4-byod-conditional-access-governance/
├── phase-5-exchange-online-mail-flow-audit/
├── phase-6-web-only-access-governance/
├── phase-7-entra-app-registration-audit/
├── phase-8-m365-incident-response-security-triage/
├── phase-9-data-protection-compliance-operations/
├── scripts/
│   ├── m365-reports/
│   └── m365-admin-toolkit/
├── sample-reports/
├── dashboard/
├── index.html
└── LICENSE
```

---

## Prerequisites

| Requirement | Details |
|---|---|
| PowerShell | Version 7+ |
| Microsoft Graph SDK | `Install-Module Microsoft.Graph -Force` |
| Exchange Online | `Install-Module ExchangeOnlineManagement -Force` (Phase 5) |
| M365 Tenant | Admin account with appropriate role assignments |
| Entra ID P2 | Required for PIM and Identity Protection scripts |

---

## Quick Start

```powershell
# Clone the repository
git clone https://github.com/rahatislamanik-spec/Enterprise-IT-Security-Operations-Toolkit.git
cd Enterprise-IT-Security-Operations-Toolkit

# Phase 1 — Tenant health report
./scripts/m365-reports/tenant-health.ps1

# Phase 5 — Exchange mail flow audit
./phase-5-exchange-online-mail-flow-audit/scripts/exchange-mail-flow-audit.ps1

# Phase 7 — App registration audit
./phase-7-entra-app-registration-audit/scripts/entra-app-registration-audit.ps1

# Phase 8 — Initial security triage
./phase-8-m365-incident-response-security-triage/scripts/invoke-m365-incident-response.ps1
```

---

## Core Technologies

PowerShell 7 · Microsoft Graph PowerShell SDK · Microsoft 365 · Microsoft Entra ID · Microsoft Intune · Microsoft Defender · Microsoft Purview · Exchange Online PowerShell · Conditional Access · Identity Protection · HTML / CSS / JavaScript · GitHub

---

## Lab Environment Disclaimer

This toolkit was developed in isolated Microsoft 365 E3 and E5 lab tenants created exclusively for security operations simulation, governance workflow testing, automation engineering, and portfolio demonstration.

Reports and screenshots are preserved as public lab evidence to show reporting format, audit logic, and operational workflow. Public exports use pseudonymized names, domains, addresses, and identifiers where needed. They are not production customer records or confidential organizational data.

---

## 🌐 Portfolio Ecosystem

| Layer | Project | Focus |
|---|---|---|
| 01 — Network Foundation | [Enterprise IT Network Diagnostics Toolkit](https://github.com/rahatislamanik-spec/Enterprise-IT-Network-Diagnostics-Toolkit) | DNS · Connectivity · Network Diagnostics |
| 02 — User Lifecycle | [Project Arabesque](https://github.com/rahatislamanik-spec/Project-Arabesque) | Onboarding · Offboarding · M365 Automation |
| 03 — Identity & Security | **You are here** | Entra ID · Intune · Defender · Zero Trust |
| 04 — M365 Operations | [Meridian Institute M365 Lab](https://github.com/rahatislamanik-spec/Meridian-Institute-M365-Lab) | Exchange · Teams · SharePoint · Purview |

👉 [View Full Portfolio](https://rahatislamanik-spec.github.io/IT-Portfolio-Rahat-Islam-Anik/)

---

*Built by Md Rahat Islam Anik — Microsoft 365 Security Operations Portfolio*
*[LinkedIn](https://linkedin.com/in/rahatislamanik) · [GitHub](https://github.com/rahatislamanik-spec) · [Portfolio](https://rahatislamanik-spec.github.io/IT-Portfolio-Rahat-Islam-Anik/)*

## 🔗 Related Portfolio Projects

| Project | Description |
|---|---|
| [AD Identity Operations Toolkit](https://github.com/rahatislamanik-spec/AD-Identity-Operations-Toolkit) | Enterprise AD governance — stale accounts, privileged access, service account security, OSFI E-21 |
| [Meridian Institute M365 Lab](https://github.com/rahatislamanik-spec/Meridian-Institute-M365-Lab) | End-to-end M365 tenant governance simulation — Defender XDR, Entra ID, Secure Score |
| [Enterprise IT Network Diagnostics Toolkit](https://github.com/rahatislamanik-spec/Enterprise-IT-Network-Diagnostics-Toolkit) | Cross-platform PowerShell network diagnostics with HTML reporting |
