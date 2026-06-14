# Evidence Map

This map connects each phase of the Enterprise IT Security Operations Toolkit to the scripts, reports, screenshots, and hiring relevance shown in the repository.

> Public evidence note: reports and screenshots are preserved from isolated Microsoft 365 lab tenants to demonstrate workflow, reporting structure, and audit logic. They are lab evidence, not production customer records.

| Phase | Purpose | Evidence | Hiring relevance |
|---|---|---|---|
| Phase 1 — Enterprise Operations Foundation | Tenant health, identity hygiene, license governance, MFA review, CA audit, privileged access review | `scripts/m365-reports/`, `scripts/m365-admin-toolkit/`, `sample-reports/m365/` | Microsoft 365 Administrator, IT Systems Analyst, Cloud Support |
| Phase 2 — Identity Threat & Security Operations | Identity Protection audit workflows, Secure Score, guest user governance | Phase 2 scripts plus retained Secure Score report; zero-result exports documented in README | Entra ID Administrator, Security Operations, M365 Admin |
| Phase 3 — Endpoint Enrollment & Intune Operations | Company Portal enrollment, Intune device visibility, ownership, and compliance-state review | 3 sanitized Phase 3 screenshots and README | Endpoint Administrator, Intune Administrator, IT Support |
| Phase 4 — BYOD Conditional Access Governance | BYOD classification, compliant-device policy review, Intune compliance evidence | Phase 4 scripts and screenshots | Entra ID, Conditional Access, Intune, Zero Trust access |
| Phase 5 — Exchange Online Mail Flow Audit | Mailbox forwarding, inbox rules, transport rules, anti-spam policy audit | Exchange audit script, CSV reports, Exchange screenshots | Microsoft 365 Administrator, Exchange Online Administrator |
| Phase 6 — Web-Only Access Governance | App-enforced restrictions for unmanaged-device browser access | Web-only audit script, before/after report, screenshots | Conditional Access, SharePoint/Exchange access governance |
| Phase 7 — Entra ID App Registration Audit | App registrations, service principals, OAuth grants, high-risk permissions, credential expiry | App registration script, 4 CSV reports, Entra screenshots | Identity Security, Entra ID, Cloud Security |
| Phase 8 — M365 Initial Security Triage | Initial identity, license, group, and role evidence collection | Triage script plus sanitized user/license/group/role reports | Security Operations, M365 Admin, IT Support escalation |
| Phase 9 — Data Protection & Compliance Operations | DLP design, compliance posture review, insider-risk planning, information protection, adaptive scope, auto-labeling, and retention governance | `phase-9-data-protection-compliance-operations/README.md` and 21 sanitized Purview screenshots | Purview Administrator, M365 Security, Compliance Operations, GRC support |
| Phase 10 — Purview Retention Policy Framework | Target-state retention taxonomy, labels, records management, legal hold, archiving, and deletion governance | `phase-10-purview-retention-framework/README.md`, framework document, and retention audit script; production execution evidence is not claimed | Purview Administrator, Compliance Administrator, Records and Information Governance |
| Phase 11 — Purview DLP Investigation Runbook | Target-state DLP triage, audit review, eDiscovery, Insider Risk escalation, remediation, and reporting | `phase-11-purview-dlp-investigation-runbook/README.md`, eight-step runbook, and DLP alert-reporting script; production incident outcomes are not claimed | Security Operations, Purview Administrator, Compliance Operations, Incident Triage |

## Lab Scope

| Area | Status | Notes |
|---|---|---|
| Tenant operations | Implemented in lab | Scripts were executed against isolated Microsoft 365 lab tenants. |
| Conditional Access | Configured and audited | Several controls are documented in report-only mode for safe validation. |
| Incident response | Triage simulation | The workflow supports early evidence collection, not full forensic investigation. |
| Intune endpoint operations | Enrollment and managed-device evidence | Screenshots show a single macOS lab device, not production fleet ownership or Defender incident operations. |
| Sample reports | Preserved as sanitized evidence | Reports retain technical fields and findings while public identifiers are pseudonymized. |
| Purview controls | Configured and reviewed in lab | DLP remained in simulation mode; screenshots do not prove enforcement, triggered alerts, investigations, label publication, or retention outcomes. |

## Interview Talking Points

| Topic | What to be ready to explain |
|---|---|
| Microsoft Graph scopes | Why each script requests specific read/write permissions and how least privilege would be handled in production. |
| Report-only Conditional Access | Why report-only validation is used before enforcement and how rollout impact would be monitored. |
| OAuth grant risk | Why permissions such as `Directory.ReadWrite.All` and `User.ReadWrite.All` require review. |
| Exchange forwarding audit | Why mailbox forwarding, inbox rules, transport rules, and anti-spam policies matter for BEC defense. |
| Incident triage limits | Difference between initial triage evidence collection and formal incident response/forensics. |
| Purview evidence limits | Difference between policy configuration, simulation, operational enforcement, triggered incidents, and regulatory certification. |
