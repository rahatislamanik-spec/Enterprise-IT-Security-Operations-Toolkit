# Phase 10 — Microsoft Purview Retention Policy Framework

> **Enterprise-IT-Security-Operations-Toolkit**
> End-to-end data lifecycle governance framework using Microsoft Purview retention policies, retention labels, records management, and legal hold procedures.

---

## Phase Summary

Phase 10 documents a target-state retention policy framework for **Crestline Retail Group**, a fictional 300-user, 6-site Microsoft 365 E5 enterprise environment.

This framework establishes data lifecycle governance across all Microsoft 365 workloads — Exchange Online, SharePoint Online, OneDrive, Teams channels, and Teams chats — aligned to PIPEDA, Canadian PII compliance requirements, and internal business policy.

---

## Phase Documents

| Document | Description |
|---|---|
| [PURVIEW-Retention-Policy-Framework.md](./PURVIEW-Retention-Policy-Framework.md) | Full retention taxonomy, label hierarchy, records management workflow, legal hold procedure, and PIPEDA alignment |
| [scripts/Get-RetentionPolicyAudit.ps1](./scripts/Get-RetentionPolicyAudit.ps1) | PowerShell script to audit all retention policies, labels, and unlabeled content locations |

---

## Retention Policy Taxonomy

| Workload | Retention Period | Basis |
|---|---|---|
| Exchange Online | 7 years | Regulatory requirement |
| SharePoint Online | 5 years | Business requirement |
| OneDrive | 5 years | Business requirement |
| Teams channel messages | 3 years | Internal policy |
| Teams chats | 1 year | Internal policy |

---

## Retention Label Hierarchy

| Label | Retention Period | Classification |
|---|---|---|
| Financial Records | 7 years | Regulatory |
| HR Records | 7 years | Employment law |
| Client Records | 5 years | Business requirement |
| Operational Records | 3 years | Internal policy |
| Transactional Records | 1 year | Internal policy |

---

## Outcome

> Design outcome: a multi-workload retention taxonomy, label hierarchy, records-management workflow, legal-hold procedure, and audit approach for a fictional enterprise. Production deployment and compliance outcomes are not claimed.

---

## Skills Demonstrated

`Microsoft Purview` · `Retention Policies` · `Retention Labels` · `Records Management` · `Legal Hold` · `Data Lifecycle Governance` · `PIPEDA Compliance` · `Exchange Online` · `SharePoint Online` · `Microsoft Teams` · `PowerShell` · `Compliance Administration`

---

Built by **Md Rahat Islam Anik**
Microsoft 365 Security Operations Portfolio
