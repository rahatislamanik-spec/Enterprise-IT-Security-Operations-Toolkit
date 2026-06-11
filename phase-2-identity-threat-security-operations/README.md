phase-2-identity-threat-security-operations/README.md

# Phase 2 — Identity Threat & Security Operations

## Overview

Phase 2 of the Enterprise IT Security Operations Toolkit focuses on identity security, Microsoft Entra ID threat visibility, governance reporting, Secure Score analysis, and operational security monitoring workflows.

This phase models Identity Protection and security-review processes commonly performed by Microsoft 365 administrators, identity analysts, and security operations teams.

The objective of this phase is to improve operational visibility into identity-based threats, governance posture, authentication security, and Microsoft 365 tenant security posture using Microsoft Graph and PowerShell automation.

---

# Operational Goals

This phase was designed to simulate and automate operational identity security workflows that are commonly handled manually across multiple Microsoft 365 administration portals.

The toolkit focuses on:

- Identity threat visibility
- Risk detection monitoring
- Risky user auditing
- Governance reporting
- Secure Score visibility
- Authentication security analysis
- Guest user governance
- Security posture reporting
- Operational evidence collection
- Administrative reporting automation

The goal is to reduce manual review effort while improving identity-security visibility, governance consistency, and escalation readiness.

## Evidence Status

The Secure Score report contains retained lab output. Risky-user, risk-detection, and guest-governance runs returned no rows in the captured tenant state; their zero-byte exports were removed because empty files add no interview value. The scripts remain available to demonstrate query logic and can generate populated reports when matching tenant data exists.

---

# Current Reporting Modules

## Risky User Audit

This workflow identifies risky users detected by Microsoft Entra ID Identity Protection.

Operational objectives include:

- High-risk user visibility
- Identity compromise monitoring
- Risk state tracking
- Governance reporting
- Security investigation support

---

## Risk Detection Reporting

This workflow captures identity risk detections generated within Microsoft Entra ID Identity Protection.

Examples may include:

- Impossible travel detections
- Anonymous IP activity
- Malware-linked sign-ins
- Suspicious authentication attempts
- Unfamiliar sign-in properties

The reporting workflow supports:

- Threat visibility
- Security operations analysis
- Incident investigation workflows
- Identity monitoring

---

## Microsoft Secure Score Reporting

This workflow captures Microsoft Secure Score operational metrics.

The reporting pipeline provides visibility into:

- Current tenant security posture
- Security improvement opportunities
- Security score tracking
- Governance benchmarking
- Operational maturity visibility

Current Lab Secure Score:

```text
146.26 / 204
