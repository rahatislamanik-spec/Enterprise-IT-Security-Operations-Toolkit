phase-2-identity-threat-security-operations/README.md

# Phase 2 — Identity Threat & Security Operations

## Overview

Phase 2 of the Enterprise IT Security Operations Toolkit focuses on identity security, Microsoft Entra ID threat visibility, governance reporting, Secure Score analysis, and operational security monitoring workflows.

This phase simulates enterprise-level Identity Protection and security operations processes commonly performed by Tier 2 / Tier 3 administrators, security analysts, governance teams, and SOC environments.

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

The goal is to reduce manual operational overhead while improving security visibility, governance consistency, and incident response readiness.

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