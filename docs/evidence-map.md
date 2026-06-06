# Evidence Map

This map connects each phase of the Enterprise IT Security Operations Toolkit to the scripts, reports, screenshots, and hiring relevance shown in the repository.

> Public evidence note: reports and screenshots are preserved from isolated Microsoft 365 lab tenants to demonstrate workflow, reporting structure, and audit logic. They are lab evidence, not production customer records.

| Phase | Purpose | Evidence | Hiring relevance |
|---|---|---|---|
| Phase 1 — Enterprise Operations Foundation | Tenant health, identity hygiene, license governance, MFA review, CA audit, privileged access review | `scripts/m365-reports/`, `scripts/m365-admin-toolkit/`, `sample-reports/m365/` | Microsoft 365 Administrator, IT Systems Analyst, Cloud Support |
| Phase 2 — Identity Threat & Security Operations | Risky user review, risk detections, Secure Score, guest user governance | `phase-2-identity-threat-security-operations/scripts/`, reports, screenshots | Entra ID Administrator, Security Operations, M365 Admin |
| Phase 3 — Endpoint Security & Defender Operations | Intune device visibility, Defender portal evidence, endpoint compliance posture | Phase 3 screenshots and README | Endpoint Administrator, Intune Administrator, Security Operations |
| Phase 4 — BYOD Conditional Access Governance | BYOD classification, compliant-device policy review, Intune compliance evidence | Phase 4 scripts and screenshots | Entra ID, Conditional Access, Intune, Zero Trust access |
| Phase 5 — Exchange Online Mail Flow Audit | Mailbox forwarding, inbox rules, transport rules, anti-spam policy audit | Exchange audit script, CSV reports, Exchange screenshots | Microsoft 365 Administrator, Exchange Online Administrator |
| Phase 6 — Web-Only Access Governance | App-enforced restrictions for unmanaged-device browser access | Web-only audit script, before/after report, screenshots | Conditional Access, SharePoint/Exchange access governance |
| Phase 7 — Entra ID App Registration Audit | App registrations, service principals, OAuth grants, high-risk permissions, credential expiry | App registration script, 4 CSV reports, Entra screenshots | Identity Security, Entra ID, Cloud Security |
| Phase 8 — M365 Incident Response Security Triage | Initial evidence collection for suspicious account activity | Incident triage script, user/license/group/role reports, screenshots | Security Operations, M365 Admin, IT Support escalation |

## Lab Scope

| Area | Status | Notes |
|---|---|---|
| Tenant operations | Implemented in lab | Scripts were executed against isolated Microsoft 365 lab tenants. |
| Conditional Access | Configured and audited | Several controls are documented in report-only mode for safe validation. |
| Incident response | Triage simulation | The workflow supports early evidence collection, not full forensic investigation. |
| Defender / Intune | Portal and governance evidence | Screenshots show visibility and review workflows, not production fleet ownership. |
| Sample reports | Preserved as evidence | Reports show output schema and audit logic from lab data. |

## Interview Talking Points

| Topic | What to be ready to explain |
|---|---|
| Microsoft Graph scopes | Why each script requests specific read/write permissions and how least privilege would be handled in production. |
| Report-only Conditional Access | Why report-only validation is used before enforcement and how rollout impact would be monitored. |
| OAuth grant risk | Why permissions such as `Directory.ReadWrite.All` and `User.ReadWrite.All` require review. |
| Exchange forwarding audit | Why mailbox forwarding, inbox rules, transport rules, and anti-spam policies matter for BEC defense. |
| Incident triage limits | Difference between initial triage evidence collection and formal incident response/forensics. |
