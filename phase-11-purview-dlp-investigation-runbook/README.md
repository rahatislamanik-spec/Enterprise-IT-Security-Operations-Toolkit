# Phase 11 — Microsoft Purview DLP Investigation Runbook

> **Enterprise-IT-Security-Operations-Toolkit**
> Data Loss Prevention investigation workflow using Microsoft Purview compliance portal, Activity Explorer, Unified Audit Log, eDiscovery, and Insider Risk Management.

---

## Phase Summary

Phase 11 documents a structured DLP incident investigation methodology for **Crestline Retail Group**, a fictional 300-user, 6-site Microsoft 365 E5 enterprise environment.

This runbook captures a target-state sequence for triaging DLP policy alerts, identifying root causes, escalating insider-risk indicators, and documenting investigation outcomes. It is a lab design artifact and does not claim production incident history or control effectiveness.

---

## Phase Documents

| Document | Description |
|---|---|
| [PURVIEW-DLP-Investigation-Runbook.md](./PURVIEW-DLP-Investigation-Runbook.md) | Full 8-step DLP investigation runbook with root cause scenarios and escalation criteria |
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

> Lab outcome: an eight-step investigation workflow, escalation model, and reporting structure were documented for a fictional enterprise scenario. No production incident outcome is claimed.

---

## Skills Demonstrated

`Microsoft Purview` · `Data Loss Prevention` · `DLP Investigation` · `Activity Explorer` · `Unified Audit Log` · `eDiscovery` · `Insider Risk Management` · `PIPEDA Compliance` · `PowerShell` · `Incident Response` · `Security Operations`

---

Built by **Md Rahat Islam Anik**
Microsoft 365 Security Operations Portfolio
