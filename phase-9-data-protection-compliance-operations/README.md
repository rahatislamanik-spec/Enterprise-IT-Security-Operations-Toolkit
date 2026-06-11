# Phase 9 - Data Protection & Compliance Operations

## Executive Summary

Phase 9 extends the security operations toolkit into Microsoft Purview data protection and compliance administration. The lab evidence covers Data Loss Prevention (DLP) policy design, Compliance Manager assessment review, Insider Risk Management policy planning, sensitivity-label hierarchy review, and retention-label configuration.

This phase documents configuration and review activities in an isolated Microsoft 365 demonstration environment. It does not claim production enforcement, regulatory certification, triggered incidents, completed investigations, or measured risk reduction.

## Business Purpose

Security operations must protect sensitive information without interrupting legitimate work. This phase demonstrates how a Microsoft 365 administrator can:

- Scope DLP controls across Exchange, SharePoint, OneDrive, and Teams.
- Define sensitive information conditions, user notifications, overrides, and alert behavior.
- Validate a DLP policy in simulation mode before considering enforcement.
- Review Compliance Manager assessments and improvement actions.
- Design an Insider Risk Management policy using data-leak indicators and priority content.
- Review sensitivity and retention labels as information-governance controls.

## Evidence Status

| Capability | Evidence retained | Status and limitation |
|---|---|---|
| DLP policy design | Locations, sensitive information types, alert settings, user notifications, override controls, and rule summary | Configuration evidence from a lab tenant |
| DLP validation | Simulation-mode selection and policy status | The policy remained in simulation; no production enforcement or matched-event result is claimed |
| Compliance Manager | Assessment inventory, 57% score snapshot, and baseline improvement actions | A point-in-time lab posture view, not proof of regulatory compliance |
| Insider Risk Management | Data Leaks template, priority labels, triggering events, and policy health | Policy-design and health evidence; no alert, case, or investigation outcome is claimed |
| Sensitivity labels | Classification hierarchy plus publishing-policy review and creation | Policy creation is shown; propagation and end-user label application are not claimed |
| Retention and auto-labeling | Seven-year retention label, adaptive scope, and simulation-mode auto-labeling policy | Configuration and creation are shown; matched content, enforcement, and disposition outcomes are not claimed |

## Evidence Gallery

### Data Loss Prevention

![DLP workload locations](screenshots/01-dlp-policy-locations.png)

**DLP workload locations:** Shows policy scope across Microsoft 365 workloads. The warning banners also preserve an important lab limitation: optional managed-app prerequisites were not fully configured.

![DLP sensitive information types](screenshots/02-dlp-sensitive-information-types.png)

**Sensitive information conditions:** Shows the sensitive information types and confidence settings selected for the DLP rule.

![DLP alert settings](screenshots/03-dlp-alert-settings.png)

**Alert configuration:** Shows incident-report and alert behavior configured for policy matches.

![DLP user notifications and overrides](screenshots/04-dlp-user-notifications-overrides.png)

**User interaction controls:** Shows policy tips, override behavior, and business-justification options intended to balance protection with legitimate work.

![DLP advanced rule summary](screenshots/05-dlp-rule-summary.png)

**Advanced rule summary:** Consolidates the rule conditions and actions before policy validation.

![DLP simulation mode](screenshots/06-dlp-simulation-mode.png)

**Safe rollout mode:** Shows simulation selected before enforcement so administrators can evaluate potential impact.

![DLP policy status](screenshots/07-dlp-policy-status.png)

**Policy status:** Shows the lab policy in simulation mode with no match found at the time of capture. This is configuration evidence, not proof of a triggered DLP event.

### Compliance Manager

![Compliance Manager assessments](screenshots/08-compliance-manager-assessments.png)

**Assessment inventory:** Shows the available assessment workspace used to organize compliance improvement work.

![Compliance Manager score](screenshots/09-compliance-score-overview.png)

**Compliance score snapshot:** Shows a 57% point-in-time lab score and outstanding improvement actions. The score is a prioritization aid, not a certification or legal-compliance conclusion.

![Data Protection Baseline actions](screenshots/10-data-protection-baseline-actions.png)

**Improvement-action review:** Shows the Data Protection Baseline assessment used to identify incomplete controls and remediation priorities.

### Insider Risk Management

![Insider Risk Data Leaks template](screenshots/11-insider-risk-data-leaks-template.png)

**Policy template selection:** Shows the Data Leaks template considered for an insider-risk monitoring workflow.

![Insider Risk priority labels](screenshots/12-insider-risk-priority-labels.png)

**Priority content:** Shows sensitivity labels selected as higher-value content signals within the policy design.

![Insider Risk triggering events](screenshots/13-insider-risk-triggering-events.png)

**Triggering events and indicators:** Shows the event and activity categories considered for risk scoring.

![Insider Risk policy health](screenshots/14-insider-risk-policy-health.png)

**Policy health view:** Shows policy warnings, recommendations, and healthy-policy counts. Zero alerts are visible, so no incident outcome is claimed.

### Information Protection & Lifecycle Management

![Retention label configuration](screenshots/15-retention-label-configuration.png)

**Retention-label configuration:** Shows a seven-year retention period followed by automatic deletion. Creator details and tenant-specific browser information were sanitized.

![Sensitivity label hierarchy](screenshots/16-sensitivity-label-hierarchy.png)

**Sensitivity-label hierarchy:** Shows a classification structure ranging from Personal and Public through Highly Confidential. It demonstrates label taxonomy review, not label publication or user adoption.

### Adaptive Scope & Automated Labeling

![Adaptive scope created](screenshots/17-adaptive-scope-created.png)

**Adaptive scope creation:** Confirms that a user-based adaptive scope was created for policy targeting. Microsoft notes that scope membership can take time to populate, so this does not claim immediate policy coverage.

![Auto-labeling policy review](screenshots/18-auto-labeling-policy-review.png)

**Auto-labeling review:** Shows the policy name, Exchange and OneDrive locations, adaptive scope, seven-year retention label, and simulation mode before creation.

![Auto-labeling policy created](screenshots/19-auto-labeling-policy-created.png)

**Auto-labeling policy creation:** Confirms successful creation in simulation mode. No labels are claimed as applied and no simulation match results are claimed.

### Sensitivity Label Publication

![Sensitivity label publishing policy review](screenshots/20-sensitivity-label-policy-review.png)

**Publishing-policy review:** Shows the selected labels, target account scope, default-label settings, and justification requirement before creation.

![Sensitivity label publishing policy created](screenshots/21-sensitivity-label-policy-created.png)

**Publishing-policy creation:** Confirms successful policy creation. The portal notes that publication can take up to 24 hours; propagation and end-user use are therefore not claimed.

## Security and Privacy Notes

- Browser chrome containing tenant identifiers was cropped from retained evidence.
- Visible account indicators and creator names were blurred where applicable.
- Policy names, configuration values, workload scope, simulation state, scores, and control settings were preserved.
- Screenshots originate from a lab or simulated enterprise environment and contain no production customer records.

## Hiring Relevance

This phase supports roles involving Microsoft 365 administration, Purview administration, information protection, security operations, and compliance support. It demonstrates policy design, staged validation, evidence handling, governance interpretation, and the ability to communicate technical limitations honestly.
