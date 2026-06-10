# Phase 9 — Microsoft Purview DLP Investigation Runbook

> **Enterprise-IT-Security-Operations-Toolkit**
> Data Loss Prevention investigation workflow using Microsoft Purview compliance portal, Activity Explorer, Unified Audit Log, eDiscovery, and Insider Risk Management.

---

## Phase Summary

Phase 9 documents the structured DLP incident investigation methodology developed and operated at **Port Food Mart** over a 3.5-year tenure as sole IT administrator for a 300-user, 6-site Microsoft 365 E5 environment in Tampa, FL.

This runbook captures the exact investigation sequence used to investigate DLP policy alerts, identify root causes, escalate insider risk events, and document outcomes — resulting in **zero unauthorized data disclosure incidents** across the full tenure.

---

## Phase Documents

| Document | Description |
|---|---|
| [PURVIEW-DLP-Investigation-Runbook-PortFoodMart.md](./PURVIEW-DLP-Investigation-Runbook-PortFoodMart.md) | Full 8-step DLP investigation runbook with root cause scenarios and escalation criteria |
| [scripts/Get-DLPAlertReport.ps1](./scripts/Get-DLPAlertReport.ps1) | PowerShell script to export DLP alerts by date range, policy, and severity |

---

## Investigation Scope

- **Environment:** 300 users · 6 sites · Microsoft 365 E5
- **Regulatory Framework:** PIPEDA · Canadian PII compliance
- **Sensitive Information Types:** Canadian SIN · Passport numbers · Financial account data
- **Tools Used:** Microsoft Purview compliance portal · Activity Explorer · Unified Audit Log · eDiscovery · Insider Risk Management

---

## Investigation Sequence

```text
DLP Alert Triggered in Purview
          ↓
Step 1: DLP Alert Queue — triage and severity classification
          ↓
Step 2: Activity Explorer — user behavior timeline
          ↓
Step 3: Unified Audit Log — full M365 activity record
          ↓
Step 4: eDiscovery Content Search — evidence trail
          ↓
Step 5: Root Cause Identification (Scenario A / B / C)
          ↓
Step 6: Insider Risk Management escalation decision
          ↓
Step 7: Policy remediation
          ↓
Step 8: Incident documentation and stakeholder reporting
```

---

## Outcome

> Zero unauthorized data disclosure incidents across a 3.5-year tenure managing 300 users and 6 sites under PIPEDA and Canadian PII compliance requirements.

---

## Skills Demonstrated

`Microsoft Purview` · `Data Loss Prevention` · `DLP Investigation` · `Activity Explorer` · `Unified Audit Log` · `eDiscovery` · `Insider Risk Management` · `PIPEDA Compliance` · `PowerShell` · `Incident Response` · `Security Operations`

---

Built by **Md Rahat Islam Anik**
Microsoft 365 Security Operations Portfolio
