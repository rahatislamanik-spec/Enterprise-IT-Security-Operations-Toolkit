# Microsoft Purview DLP Investigation Runbook — Port Food Mart

---

## Metadata

| Field | Detail |
|---|---|
| **Company** | Port Food Mart |
| **Environment** | 300 users · 6 sites · Microsoft 365 E5 · Tampa, FL |
| **Administrator** | Md Rahat Islam Anik — Sole IT Administrator |
| **Tenure** | 3.5 years |
| **Date** | June 2026 |
| **Phase** | Phase 9 — Microsoft Purview DLP Investigation Runbook |
| **Regulatory Framework** | PIPEDA · Canadian PII Compliance |
| **Outcome** | Zero unauthorized data disclosure incidents |

---

## Business Context

Port Food Mart operates across 6 sites with 300 Microsoft 365 E5 users handling daily business operations including procurement, HR, finance, and customer-facing retail transactions. As the sole IT administrator, the responsibility for data loss prevention encompasses all Microsoft 365 workloads — Exchange Online, SharePoint Online, OneDrive for Business, Microsoft Teams, and endpoint devices.

The business operates under **PIPEDA (Personal Information Protection and Electronic Documents Act)** and handles regulated sensitive data categories including:

- **Canadian Social Insurance Numbers (SIN)** — collected in HR and payroll workflows
- **Passport numbers** — collected for employee onboarding and background processes
- **Financial account data** — collected in procurement, accounts payable, and payroll systems

A DLP incident at Port Food Mart carries direct regulatory exposure under PIPEDA, reputational risk to the brand across 6 active retail sites, and potential civil liability. The investigation runbook documented here was developed and refined over 3.5 years to ensure consistent, fast, and fully documented responses to every DLP alert.

---

## Sensitive Information Types Monitored

| Sensitive Information Type | Microsoft Purview Built-in Type | Business Context at Port Food Mart |
|---|---|---|
| Canadian Social Insurance Number | `Canada Social Insurance Number` | HR onboarding, payroll, tax documentation |
| Canadian Passport Number | `Canada Passport Number` | Employee identity verification, onboarding |
| Canadian Bank Account Number | `Canada Bank Account Number` | Accounts payable, payroll direct deposit |
| Credit Card Number | `Credit Card Number` | Retail transaction records, procurement |
| Canadian Driver's License | `Canada Driver's License Number` | Fleet management, HR identity records |

---

## DLP Policies in Scope

| Policy Name | Workloads Covered | Mode | Sensitive Types Covered |
|---|---|---|---|
| `PortFoodMart-PIPEDA-Core` | Exchange, SharePoint, OneDrive, Teams | Enforce | Canadian SIN, Passport, Bank Account |
| `PortFoodMart-Financial-Protection` | Exchange, SharePoint, OneDrive | Enforce | Credit Card, Bank Account |
| `PortFoodMart-HR-Records-Protection` | Exchange, SharePoint, OneDrive | Enforce | Canadian SIN, Passport, Driver's License |
| `PortFoodMart-Endpoint-DLP` | Endpoint devices | Enforce | Canadian SIN, Credit Card |
| `PortFoodMart-Teams-Protection` | Teams chats and channel messages | Enforce | Canadian SIN, Financial data |

---

## DLP Investigation Sequence

### Step 1 — DLP Alert Queue in Microsoft Purview Compliance Portal

**Location:** `Microsoft Purview compliance portal → Data loss prevention → Alerts`

The investigation begins at the DLP Alert Queue. Each alert is triaged using the following criteria before proceeding.

**Initial triage fields to review:**

| Field | Purpose |
|---|---|
| Alert name | Identifies the triggered policy |
| Severity | High / Medium / Low — determines urgency of investigation |
| Status | New / Investigating / Resolved — track investigation state |
| Policy matched | Which DLP policy was violated |
| User | The identity that triggered the alert |
| Workload | Exchange / SharePoint / OneDrive / Teams / Endpoint |
| Location | Which site or mailbox generated the alert |
| Matched content | Sensitive information type detected |
| Time | Alert generation timestamp |

**Severity classification at Port Food Mart:**

| Severity | Response Time | Example Trigger |
|---|---|---|
| High | Within 1 hour | Canadian SIN detected in outbound email to external domain |
| Medium | Within 4 hours | Financial account data found in SharePoint shared with external users |
| Low | Within 24 hours | Internal sharing of HR data without label applied |

**Action:** Set alert status to `Investigating` and note the alert ID, policy name, user UPN, workload, and timestamp before proceeding to Step 2.

---

### Step 2 — Activity Explorer: User Behavior Timeline

**Location:** `Microsoft Purview compliance portal → Data classification → Activity Explorer`

Activity Explorer provides a unified timeline of user activities involving sensitive data across all Microsoft 365 workloads. It is the primary tool for understanding what a user did before, during, and after the DLP alert was generated.

**Filter settings for DLP investigation:**

```text
Date range:     [Alert timestamp - 48 hours] to [Alert timestamp + 24 hours]
User:           [User UPN from Step 1]
Activity:       DLP policy matched, DLP rule matched, Sensitivity label applied,
                File copied, File downloaded, File printed, File shared
Workload:       All (or filter to the workload from Step 1)
```

**Key activities to identify in Activity Explorer:**

| Activity Type | What It Reveals |
|---|---|
| `DLPRuleMatch` | Exact rule within the policy that triggered |
| `SensitiveInfoTypeMatch` | Which sensitive information type was detected |
| `FileDownloaded` | Evidence of data exfiltration via download |
| `FileCopiedToClipboard` | Evidence of clipboard-based exfiltration |
| `FilePrinted` | Evidence of hardcopy data exfiltration |
| `FileSharedExternally` | Evidence of external sharing to unauthorized recipients |
| `CloudAppActivities` | Third-party app data exposure |
| `EndpointActivity` | Device-level data movement (USB, network share) |

**Document:** Export the Activity Explorer timeline for the relevant user and timeframe. Note any anomalous activity patterns — unusual access times, access from atypical locations, or volumes inconsistent with normal behavior.

---

### Step 3 — Unified Audit Log: Full Microsoft 365 Activity Record

**Location:** `Microsoft Purview compliance portal → Audit → New search`

The Unified Audit Log (UAL) provides the complete, tamper-resistant record of all Microsoft 365 activities across the tenant. This step expands the investigation beyond DLP-specific events to capture the full user activity context.

**Search configuration:**

```text
Date range:     [Alert timestamp - 72 hours] to [Alert timestamp + 48 hours]
Users:          [User UPN from Step 1]
Record types:   ExchangeItem, SharePointFileOperation, OneDriveSyncOperation,
                MicrosoftTeams, ComplianceDLPSharePoint, ComplianceDLPExchange,
                SecurityComplianceInsights
```

**Critical audit record types for DLP investigation:**

| Record Type | Activities Captured |
|---|---|
| `ComplianceDLPSharePoint` | DLP matches on SharePoint and OneDrive |
| `ComplianceDLPExchange` | DLP matches on Exchange Online email |
| `ExchangeItem` | Email send, forward, reply, delete events |
| `SharePointFileOperation` | File access, download, upload, share, delete |
| `MicrosoftTeams` | Teams chat messages, file shares, meeting activity |
| `AzureActiveDirectory` | Sign-in events, MFA activity, token issuance |

**Investigation questions answered by the UAL:**

1. Did the user send email containing sensitive data to an external address?
2. Did the user download files from SharePoint or OneDrive to a local device?
3. Did the user share documents externally through Teams or SharePoint?
4. Did the user's account show any sign-in anomalies (unusual location, device, time)?
5. Were there any failed MFA prompts or conditional access blocks around the alert time?
6. Did the user access or modify any records related to the sensitive data type involved?

**Action:** Export UAL results to CSV. Cross-reference with Activity Explorer findings from Step 2. Build a complete chronological activity narrative before proceeding.

---

### Step 4 — eDiscovery Content Search: Evidence Trail

**Location:** `Microsoft Purview compliance portal → eDiscovery → Content search`

eDiscovery Content Search is used when the DLP investigation requires retrieving the actual content involved — the email, document, or message that triggered the alert — to preserve it as evidence or to assess the full scope of exposure.

**When to use eDiscovery in a DLP investigation:**

- The alert indicates data was sent or shared externally and you need the full content of the communication
- Management or HR requires documented evidence for disciplinary proceedings
- Legal counsel requests preservation of all related communications
- The scope of the alert suggests the incident may be broader than a single event

**Content search configuration for DLP investigation:**

```text
Search name:    DLP-Investigation-[AlertID]-[Date]
Locations:      Exchange mailboxes (include user mailbox + sent items)
                SharePoint sites (include relevant site collections)
                OneDrive accounts (include user OneDrive)
                Teams messages (include user Teams chats and channels)

Keywords:       [Sensitive data type keywords if appropriate]
                OR
                [Document or file name identified in Activity Explorer]

Date filter:    [Alert timestamp - 7 days] to [Alert timestamp + 7 days]
```

**Evidence package from eDiscovery:**

| Evidence Item | Purpose |
|---|---|
| Email with sensitive data | Documents the exact disclosure event |
| SharePoint file version history | Shows when file was modified or shared |
| Teams message transcript | Captures conversation context |
| Attachment inventory | Identifies all files transmitted |
| External recipient list | Documents unauthorized disclosure recipients |

**Action:** Export search statistics and, where legally authorized and proportionate, export results. Preserve evidence under a legal hold if escalation to HR or legal is anticipated. Document the case ID and evidence inventory in the incident record.

---

### Step 5 — Root Cause Identification

Root cause identification determines whether the DLP alert represents a policy gap, a configuration deficiency, or deliberate user behavior. At Port Food Mart, every DLP alert is traced to one of three root cause scenarios before remediation.

---

#### Scenario A — Policy Scope Gap: Workload Not Covered

**Description:** The sensitive data was transmitted through a workload or location not covered by any active DLP policy. The policy exists but does not extend to the channel where the disclosure occurred.

**Indicators:**
- Activity Explorer shows the data movement in a workload not listed in any active DLP policy scope
- No DLP rule match appears in the UAL for the specific workload involved
- The sensitive information type involved is covered in policies for other workloads but not this one

**Examples at Port Food Mart:**
- Canadian SIN data transmitted via a Teams chat not included in the Teams protection policy scope
- Financial account data shared through a SharePoint site collection added after policy creation
- Endpoint DLP not yet deployed to a specific site's devices

**Remediation path:** → [Step 7, Option A](#option-a--policy-scope-expansion)

---

#### Scenario B — Policy in Audit Mode Only: Not Enforcing

**Description:** A DLP policy exists and covers the workload, but it is configured in `Audit` or `Test` mode rather than `Enforce` mode. The policy detected the event but took no blocking or warning action.

**Indicators:**
- Alert is present in the DLP Alert Queue but no user notification or block action was recorded
- Policy action in the Purview portal shows `Audit only` or `Test mode`
- UAL shows `DLPRuleMatch` but no corresponding `PolicyTip` or `BlockedAction` event
- User was not presented with any policy tip or override prompt

**Examples at Port Food Mart:**
- A newly created PIPEDA policy left in test mode after initial deployment
- A policy that was temporarily switched to audit mode during a policy refinement exercise and not switched back to enforce
- A cloned policy used for testing that inadvertently remained active in audit mode

**Remediation path:** → [Step 7, Option B](#option-b--policy-mode-enforcement)

---

#### Scenario C — Deliberate User Override: Insider Risk

**Description:** The DLP policy was active in enforce mode, the user was presented with a policy tip and override prompt, and the user chose to override the block and transmit the sensitive data anyway. This scenario requires escalation to Insider Risk Management.

**Indicators:**
- UAL shows `DLPRuleMatch` followed by `PolicyTipOverride` or `OverrideJustificationSubmitted`
- Activity Explorer shows `DLPOverride` activity for the user
- User provided a justification (which may be vague or implausible)
- The override occurred outside normal business hours or from an atypical location
- The external recipient is not a recognized business contact

**Examples at Port Food Mart:**
- An employee emailing their personal account with a Canadian SIN-containing file and justifying the override as "personal backup"
- An employee sharing an HR payroll document with an external party and citing "management approval" as the override reason without any corroborating approval record
- Repeated override behavior by the same user across multiple policy tips within a short timeframe

**Escalation path:** → [Step 6 — Insider Risk Management Escalation](#step-6--insider-risk-management-escalation-criteria)

---

### Step 6 — Insider Risk Management Escalation Criteria

**Location:** `Microsoft Purview compliance portal → Insider risk management`

Not every DLP alert requires escalation to Insider Risk Management (IRM). The following criteria determine when a DLP investigation at Port Food Mart crosses the threshold for IRM escalation.

**Automatic escalation triggers:**

| Trigger | Threshold | Action |
|---|---|---|
| Policy override count | 3 or more overrides within 30 days | Escalate to IRM immediately |
| High-severity alert involving external sharing | Single occurrence | Escalate to IRM same day |
| Data exfiltration indicators | Download + external share + personal email within 24 hours | Escalate to IRM immediately |
| Departing employee activity | Any DLP alert within 30 days of resignation or termination notice | Escalate to IRM immediately |
| Repeated alert — same user, same policy | 2 or more alerts within 14 days | Escalate to IRM |
| Sensitive data in personal storage | OneDrive sync to personal device or USB export | Escalate to IRM |

**IRM escalation process at Port Food Mart:**

1. Open the IRM portal and review whether the user already has an active IRM alert or case
2. If no existing case: create a new IRM case and link all DLP evidence collected in Steps 1–4
3. Assign the case to the appropriate HR contact and document the escalation in the incident record
4. Set the IRM case to `Needs review` status
5. Notify management with a summary of findings — without disclosing investigation methodology to the subject user
6. Do not confront the user until HR has reviewed the evidence and a formal process is determined

**IRM policies active at Port Food Mart:**

| IRM Policy | Trigger Indicators | Scope |
|---|---|---|
| `PortFoodMart-DataTheft-Detection` | Bulk file download, cloud egress, personal email forwarding | All users |
| `PortFoodMart-DeparingEmployee-Risk` | Resignation detected + data activity spike | Departing employees |
| `PortFoodMart-PolicyViolation-Escalation` | DLP override pattern | All users |

---

### Step 7 — Policy Remediation Steps

Remediation is performed after the root cause has been confirmed from Step 5. Select the appropriate remediation option.

---

#### Option A — Policy Scope Expansion

**Trigger:** Scenario A — Policy scope gap identified.

**Steps:**

1. Navigate to `Microsoft Purview compliance portal → Data loss prevention → Policies`
2. Open the relevant policy and select `Edit policy`
3. On the `Locations` page, add the missing workload or location:
   - For SharePoint: add the specific site collection URL or select `All SharePoint sites`
   - For Teams: enable `Teams chat and channel messages`
   - For Endpoint: enroll the missing devices in Endpoint DLP through Microsoft Intune
4. For new sites added to the environment after policy creation: establish a process to update policy scope within 5 business days of any new site going live
5. Save changes and set the policy to `Test mode` for 48 hours to validate no false-positive surge
6. Switch to `Enforce` mode after validation
7. Document the scope change in the incident record

---

#### Option B — Policy Mode Enforcement

**Trigger:** Scenario B — Policy in audit mode only.

**Steps:**

1. Navigate to `Microsoft Purview compliance portal → Data loss prevention → Policies`
2. Open the policy confirmed to be in audit/test mode
3. Select `Edit policy` → navigate to `Policy mode`
4. Change from `Test mode` or `Audit only` to `Turn it on right away`
5. Review the policy's action settings — confirm block and policy tip are configured:
   - `Restrict access or encrypt the content in Microsoft 365 locations`
   - `Show policy tips to users`
   - `Send an alert to admins when a rule match occurs`
6. Save and monitor the alert queue for the next 24 hours to confirm enforcement is active
7. Document the mode change and reason in the incident record
8. Establish a quarterly policy audit process to detect any policies in non-enforce mode

---

#### Option C — User Remediation and Access Review

**Trigger:** Scenario C — Deliberate user override (after IRM escalation in Step 6).

**Steps (pending HR process determination):**

1. Preserve all evidence — do not modify, delete, or remediate any content until HR and legal review is complete
2. Coordinate with HR on whether additional DLP controls are warranted for the specific user:
   - Increase monitoring sensitivity for the user's DLP policy tier
   - Apply a more restrictive conditional access policy
   - Remove access to specific sensitive data locations if warranted
3. After HR process concludes: apply any policy refinements to address the specific override justification used
4. Consider adding the justification text to a blocklist in the DLP policy override settings if it represents a pattern
5. Document all remediation actions and the HR outcome reference in the incident record

---

### Step 8 — Incident Documentation and Stakeholder Reporting

Every DLP investigation at Port Food Mart is closed with a complete incident record. This record serves as compliance evidence under PIPEDA and as institutional knowledge for future investigations.

**Incident record structure:**

```text
====================================================
DLP INCIDENT RECORD — PORT FOOD MART
====================================================
Incident ID:        DLP-[YYYY]-[###]
Date Opened:        [Date]
Date Closed:        [Date]
Alert ID:           [Purview alert ID]
Severity:           High / Medium / Low

SUBJECT
  User UPN:         [user@portfoodmart.com]
  Department:       [Department]
  Site:             [Site location]

INCIDENT SUMMARY
  Policy Triggered: [Policy name]
  Workload:         [Exchange / SharePoint / OneDrive / Teams / Endpoint]
  Sensitive Type:   [Canadian SIN / Passport / Financial data]
  Activity:         [Description of what the user did]
  External Party:   [Yes/No — recipient if applicable]

ROOT CAUSE
  Scenario:         [A / B / C]
  Finding:          [Detailed root cause description]

INVESTIGATION STEPS COMPLETED
  Step 1 — DLP Alert Queue:        [Completed — findings summary]
  Step 2 — Activity Explorer:      [Completed — findings summary]
  Step 3 — Unified Audit Log:      [Completed — findings summary]
  Step 4 — eDiscovery:             [Completed / Not required — reason]
  Step 5 — Root Cause:             [Scenario identified]
  Step 6 — IRM Escalation:         [Escalated / Not required — reason]
  Step 7 — Remediation:            [Option applied — details]

OUTCOME
  Data Disclosed:   Yes / No
  PIPEDA Reportable: Yes / No
  HR Action:        Yes / No — reference if applicable
  Policy Updated:   Yes / No — changes made

INVESTIGATOR
  Name:             Md Rahat Islam Anik
  Role:             Sole IT Administrator
  Signature:        ___________________
  Date:             [Date]
====================================================
```

**Stakeholder reporting at Port Food Mart:**

| Stakeholder | Report Trigger | Report Content |
|---|---|---|
| Site manager | Any High-severity alert involving their site | Non-technical summary, action taken, outcome |
| HR | Any Scenario C (deliberate override) escalation | Full incident record (redacted for investigation integrity) |
| Owner / General Manager | Any PIPEDA-reportable incident | Executive summary with regulatory implications |
| All users (post-incident) | Pattern of alerts across multiple users | General awareness reminder — no names disclosed |

**PIPEDA breach notification threshold:**
Under PIPEDA, a breach involving personal information must be reported to the Privacy Commissioner of Canada if it poses a **real risk of significant harm** to individuals. At Port Food Mart, any confirmed external disclosure of Canadian SIN, passport numbers, or financial account data is treated as a potential reportable breach pending legal review.

---

## Operational Outcomes — 3.5 Year Tenure

| Metric | Result |
|---|---|
| Unauthorized data disclosure incidents | **Zero** |
| DLP policies deployed and maintained | 5 active policies across all workloads |
| Sensitive information types monitored | Canadian SIN, Passport, Bank Account, Credit Card, Driver's License |
| PIPEDA-reportable breaches | **Zero** |
| IRM escalations | Documented and resolved through HR process |
| Policy scope gaps identified and remediated | Remediated within SLA on all occasions |
| Users who received DLP policy tip awareness | All 300 users covered by enforce-mode policies |

---

## Tools Reference

| Tool | Location in Purview | Primary Use in This Runbook |
|---|---|---|
| DLP Alert Queue | Data loss prevention → Alerts | Step 1 — Initial triage |
| Activity Explorer | Data classification → Activity Explorer | Step 2 — User behavior timeline |
| Unified Audit Log | Audit → New search | Step 3 — Full M365 activity record |
| eDiscovery Content Search | eDiscovery → Content search | Step 4 — Evidence trail |
| Insider Risk Management | Insider risk management → Cases | Step 6 — Escalation |
| DLP Policies | Data loss prevention → Policies | Step 7 — Remediation |

---

## Lab Environment Disclaimer

This runbook was developed based on a 3.5-year operational tenure managing Microsoft Purview DLP for Port Food Mart. The sensitive information type examples, policy names, and scenario descriptions are documented for portfolio and educational purposes. No actual customer records, employee personal information, or confidential business data is included in this document.

---

## Skills Demonstrated

`Microsoft Purview` · `Data Loss Prevention` · `DLP Investigation` · `Activity Explorer` · `Unified Audit Log` · `eDiscovery` · `Insider Risk Management` · `PIPEDA Compliance` · `Canadian PII` · `Incident Response` · `Security Operations` · `Stakeholder Reporting` · `Policy Remediation`

---

Built by **Md Rahat Islam Anik**
Microsoft 365 Security Operations Portfolio · Phase 9
