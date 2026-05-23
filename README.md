# Microsoft 365 Tenant Health Audit Dashboard

### PowerShell · Microsoft Graph · Entra ID · Exchange Online · Live Lab Tenant

**Md Rahat Islam Anik · George Brown College · Cloud Computing & Network Administration (T465)**

[![Live Dashboard](https://img.shields.io/badge/Live%20Dashboard-View%20Now-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)](https://rahatislamanik-spec.github.io/M365-Tenant-Health-Audit-Dashboard/)
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/rahatislamanik-spec/M365-Tenant-Health-Audit-Dashboard)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-rahatislamanik-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/rahatislamanik)

---

| Live Lab Tenant | Microsoft Graph API | Entra ID Auditing | HTML Report Output |
|:---:|:---:|:---:|:---:|

---

## Overview

This project is a PowerShell-based Microsoft 365 tenant auditing toolkit that connects to a **live lab tenant** through the **Microsoft Graph API**, inventories **Entra ID users**, exports structured audit data, and generates a browser-viewable HTML report — all from a lightweight, portable PowerShell workflow.

This is not a simulation. Every script was executed against a real M365 tenant, with real Graph API authentication, producing real audit output. The case study documents the full workflow: connection, enumeration, export, and reporting — end to end.

The project reflects the kind of operational reporting and tenant visibility work that IT administrators perform daily in enterprise Microsoft 365 environments.

---

## What Was Built

### Microsoft Graph Connection & Authentication
Authenticated to a live Microsoft 365 lab tenant using the **Microsoft Graph PowerShell SDK**. Established a secure delegated connection with the correct permission scopes to query tenant directory data — no hardcoded credentials, no workarounds.

### Entra ID User Enumeration
Used Graph API queries to inventory all **Entra ID (Azure AD) users** in the tenant. Pulled user attributes including display name, UPN, account status, and assigned licenses — the same data an M365 admin would audit during an access review or compliance check.

### CSV Audit Export
Exported enumerated user data to a structured **CSV report** — formatted for audit readiness. The output mirrors the kind of reporting artifact that would be handed to a compliance team, a manager, or reviewed during an IT audit engagement.

### HTML Audit Report Generation
Generated a **browser-viewable HTML dashboard** from the audit data — a clean, readable report that surfaces tenant health information without requiring the reader to open PowerShell or parse a CSV. Deployed via GitHub Pages for live demonstration.

### Exchange Online Administration
Connected to **Exchange Online** using the Exchange Online Management Module to perform mailbox-level administration tasks — extending the audit scope beyond Entra ID into the messaging layer of the tenant.

### Enterprise Reporting Workflow
The full pipeline — authenticate → enumerate → export → report — reflects a real enterprise M365 operational workflow. The toolkit is lightweight, portable, and built entirely in PowerShell 7 with no external dependencies beyond the Microsoft-published SDK modules.

---

## Tech Stack

| Component | Detail |
|---|---|
| Scripting | PowerShell 7 |
| Identity & Directory | Microsoft Graph PowerShell SDK · Entra ID |
| Messaging | Exchange Online Management Module |
| Reporting | CSV export · HTML dashboard generation |
| Deployment | GitHub Pages |
| Development Environment | VS Code |
| Tenant | Live Microsoft 365 Lab Tenant |

---

## Workflow

```
Authenticate to M365 tenant (Graph API)
        ↓
Query Entra ID — enumerate users & attributes
        ↓
Export structured data → audit-ready CSV
        ↓
Generate HTML report → browser-viewable dashboard
        ↓
Deploy report → GitHub Pages (live)
```

---

## Roadmap

Planned enhancements to expand tenant visibility and reporting depth:

- **Conditional Access reporting** — surface policy coverage gaps across the tenant
- **MFA status auditing** — flag users without MFA enabled, by department or role
- **License utilization tracking** — identify unassigned or underutilized M365 licenses
- **Exchange mailbox reporting** — mailbox size, last logon, delegate access summary
- **SharePoint usage analytics** — site activity, storage consumption, stale sites
- **Security Score integration** — pull Microsoft Secure Score and surface improvement actions
- **Dark-mode reporting dashboard** — improved HTML report theme and layout
- **Executive summary output** — condensed, non-technical report format for leadership

---

## Live Case Study

The full interactive case study — with workflow documentation, evidence screenshots, and the deployed HTML report — is published at:

**[rahatislamanik-spec.github.io/M365-Tenant-Health-Audit-Dashboard](https://rahatislamanik-spec.github.io/M365-Tenant-Health-Audit-Dashboard/)**

---

## Author

**Md Rahat Islam Anik**
Cloud Computing & Network Administration · George Brown College · May 2026

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/rahatislamanik)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github)](https://github.com/rahatislamanik-spec)
