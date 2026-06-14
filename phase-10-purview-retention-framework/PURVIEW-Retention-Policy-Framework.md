# Microsoft Purview Retention Policy Framework — Crestline Retail Group

---

## Metadata

| Field | Detail |
|---|---|
| **Company** | Crestline Retail Group |
| **Environment** | Fictional 300-user · 6-site · Microsoft 365 E5 enterprise environment |
| **Artifact owner** | Md Rahat Islam Anik |
| **Evidence state** | Target-state retention governance design |
| **Date** | June 2026 |
| **Phase** | Phase 10 — Microsoft Purview Retention Policy Framework |
| **Regulatory Framework** | PIPEDA · Canadian PII Compliance · Employment Law |
| **Outcome** | Multi-workload retention and records-management framework documented |

---

## Business Context

Crestline Retail Group is a fictional 300-user, 6-site Microsoft 365 E5 enterprise used to model business communications, transactional records, HR documentation, and financial data across Microsoft 365 workloads. The framework defines a target-state approach to retention, records management, archiving, deletion, and legal preservation.

**Why retention matters at Crestline Retail Group:**

Uncontrolled data retention creates two opposing risks:

1. **Under-retention:** Business records, HR documentation, financial data, and client records are deleted before their legally or operationally required retention period expires. This exposes Crestline Retail Group to regulatory non-compliance under PIPEDA, inability to respond to employment disputes, and loss of audit evidence.

2. **Over-retention:** Data is kept indefinitely without a deletion schedule. This increases storage costs, broadens the scope of any potential data breach, and creates PIPEDA exposure for retaining personal information beyond its legitimate business purpose.

The retention framework addresses both risks by proposing defined retention periods and centrally governed policies rather than relying on individual user discretion. Final periods and enforcement require legal, records-management, privacy, and business-owner approval.

**Key business drivers at Crestline Retail Group:**

| Driver | Detail |
|---|---|
| Multi-site operations | 6 sites generating independent email, document, and chat records daily |
| Regulatory compliance | PIPEDA requires personal information be retained only as long as necessary |
| Employment law | HR and payroll records must be retained per applicable employment legislation |
| Financial accountability | Financial records must be available for audit and dispute resolution |
| Legal hold readiness | The business must be able to preserve records on short notice for legal proceedings |
| Storage governance | Unmanaged retention leads to unchecked storage growth across Exchange, SharePoint, OneDrive, and Teams |

---

## Retention Policy Taxonomy

The retention policy taxonomy defines proposed base retention periods for each Microsoft 365 workload. The target scope covers the fictional six-site, 300-user tenant, subject to stakeholder approval, testing, and documented exceptions.

### Exchange Online — 7 Year Retention

| Setting | Value |
|---|---|
| **Policy name** | `CrestlineRetailGroup-Exchange-7Year-Retention` |
| **Workload** | Exchange Online mailboxes |
| **Retention period** | 7 years |
| **Retention action** | Retain and then delete |
| **Trigger** | When item was created |
| **Scope** | All mailboxes (all 300 users across 6 sites) |
| **Regulatory basis** | Business email records, PIPEDA, financial communications |

**Rationale:** Business email at Crestline Retail Group includes procurement approvals, HR communications, financial authorizations, vendor correspondence, and customer service records. A 7-year retention period aligns with standard financial record-keeping requirements and ensures availability for any employment, procurement, or regulatory dispute that may arise during the lifecycle of the business relationship.

---

### SharePoint Online — 5 Year Retention

| Setting | Value |
|---|---|
| **Policy name** | `CrestlineRetailGroup-SharePoint-5Year-Retention` |
| **Workload** | SharePoint Online site collections |
| **Retention period** | 5 years |
| **Retention action** | Retain and then delete |
| **Trigger** | When item was last modified |
| **Scope** | All SharePoint sites (all 6 site collections) |
| **Regulatory basis** | Business document management, PIPEDA |

**Rationale:** SharePoint hosts operational documents, policy documents, standard operating procedures, vendor contracts, and shared business records for all 6 Crestline Retail Group sites. A 5-year retention period provides sufficient history for operational continuity, audit response, and contract dispute resolution without creating permanent storage accumulation.

---

### OneDrive for Business — 5 Year Retention

| Setting | Value |
|---|---|
| **Policy name** | `CrestlineRetailGroup-OneDrive-5Year-Retention` |
| **Workload** | OneDrive for Business accounts |
| **Retention period** | 5 years |
| **Retention action** | Retain and then delete |
| **Trigger** | When item was last modified |
| **Scope** | All OneDrive accounts (all 300 users) |
| **Regulatory basis** | Individual user document management, PIPEDA |

**Rationale:** OneDrive accounts at Crestline Retail Group store individual user work files, locally synced documents, and personal work product. A 5-year retention period mirrors the SharePoint policy and ensures individual work files are preserved for the same operational window, while deleted user accounts (departing employees) are subject to the same retention guarantee.

---

### Microsoft Teams Channel Messages — 3 Year Retention

| Setting | Value |
|---|---|
| **Policy name** | `CrestlineRetailGroup-Teams-Channels-3Year-Retention` |
| **Workload** | Microsoft Teams channel messages |
| **Retention period** | 3 years |
| **Retention action** | Retain and then delete |
| **Trigger** | When message was created |
| **Scope** | All Teams channel messages (all teams across all 6 sites) |
| **Regulatory basis** | Business communications, operational records |

**Rationale:** Teams channel messages at Crestline Retail Group are used for operational coordination, project communications, and site-level discussions. A 3-year retention period captures the active lifecycle of most operational projects and preserves the record of decisions made in team channels without creating permanent accumulation of routine operational chat.

---

### Microsoft Teams Chats — 1 Year Retention

| Setting | Value |
|---|---|
| **Policy name** | `CrestlineRetailGroup-Teams-Chats-1Year-Retention` |
| **Workload** | Microsoft Teams private chats |
| **Retention period** | 1 year |
| **Retention action** | Retain and then delete |
| **Trigger** | When message was created |
| **Scope** | All Teams 1:1 and group chats (all 300 users) |
| **Regulatory basis** | Internal communications, proportionate retention |

**Rationale:** Teams private chats are the highest-volume, lowest-formality communication channel in the environment. A 1-year retention period retains recent operational conversations for dispute or compliance review while ensuring that informal chat traffic does not accumulate indefinitely. More sensitive content in chat is addressed through DLP policies (Phase 9) rather than extended retention.

---

## Retention Label Hierarchy

Retention labels provide record-level governance that applies to specific documents and items regardless of their location. Labels allow Crestline Retail Group to retain specific categories of records for their legally or operationally required periods — even within workloads that have shorter base retention policies.

Labels are published to Exchange Online, SharePoint Online, and OneDrive for Business, and can be applied manually by users or automatically by trainable classifiers and sensitive information type rules.

---

### Label 1 — Financial Records (7 Years)

| Setting | Value |
|---|---|
| **Label name** | `Financial Records` |
| **Retention period** | 7 years |
| **Retention action** | Retain and then delete |
| **Classification** | Regulatory requirement |
| **Regulatory basis** | Financial record-keeping, audit requirements, PIPEDA |
| **Auto-apply rule** | Sensitive information types: Credit Card Number, Canada Bank Account Number |
| **Records management** | Mark as record (immutable during retention period) |

**Examples of content at Crestline Retail Group:**
- Accounts payable invoices and payment confirmations
- Payroll records and direct deposit documentation
- Financial statements and budget documents
- Vendor payment contracts and purchase orders
- Point-of-sale reconciliation records

---

### Label 2 — HR Records (7 Years)

| Setting | Value |
|---|---|
| **Label name** | `HR Records` |
| **Retention period** | 7 years |
| **Retention action** | Retain and then delete |
| **Classification** | Employment law requirement |
| **Regulatory basis** | Employment law, PIPEDA personal information obligations |
| **Auto-apply rule** | Sensitive information types: Canada Social Insurance Number, Canada Passport Number |
| **Records management** | Mark as record (immutable during retention period) |

**Examples of content at Crestline Retail Group:**
- Employee onboarding documentation
- Tax forms containing Social Insurance Numbers
- Performance review records
- Disciplinary records and HR case files
- Employment contracts and offer letters
- Termination and resignation records

---

### Label 3 — Client Records (5 Years)

| Setting | Value |
|---|---|
| **Label name** | `Client Records` |
| **Retention period** | 5 years |
| **Retention action** | Retain and then delete |
| **Classification** | Business requirement |
| **Regulatory basis** | PIPEDA — personal information of customers |
| **Auto-apply rule** | Keyword classifiers: customer, client account, loyalty program |
| **Records management** | Standard retention (not immutable) |

**Examples of content at Crestline Retail Group:**
- Customer account records
- Loyalty program enrollment data
- Customer service correspondence
- Refund and dispute records
- Vendor relationship records

---

### Label 4 — Operational Records (3 Years)

| Setting | Value |
|---|---|
| **Label name** | `Operational Records` |
| **Retention period** | 3 years |
| **Retention action** | Retain and then delete |
| **Classification** | Internal policy |
| **Regulatory basis** | Operational continuity, internal audit |
| **Auto-apply rule** | Keyword classifiers: standard operating procedure, site operations, shift schedule |
| **Records management** | Standard retention (not immutable) |

**Examples of content at Crestline Retail Group:**
- Site standard operating procedures
- Shift scheduling and attendance records
- Inventory management documents
- Facilities maintenance records
- Staff training records and certifications

---

### Label 5 — Transactional Records (1 Year)

| Setting | Value |
|---|---|
| **Label name** | `Transactional Records` |
| **Retention period** | 1 year |
| **Retention action** | Retain and then delete |
| **Classification** | Internal policy |
| **Regulatory basis** | Routine business transactions, proportionate retention |
| **Auto-apply rule** | Keyword classifiers: daily report, transaction log, register summary |
| **Records management** | Standard retention (not immutable) |

**Examples of content at Crestline Retail Group:**
- Daily sales reports
- Register reconciliation logs
- Routine operational emails and status updates
- Internal announcements and memos

---

## Records Management Workflow

Records management applies to content labeled as `Financial Records` or `HR Records` — the two label categories marked as immutable records during their retention period.

**What "marked as record" means in Microsoft Purview:**

| Restriction | Effect |
|---|---|
| Cannot be deleted | Users cannot delete the item during the retention period |
| Cannot be modified | Users cannot edit the item after it is declared a record |
| Cannot be moved | Item cannot be moved from its location |
| Visible metadata | Record status is visible to users in SharePoint and OneDrive |
| Audit trail | All access attempts are logged in the Unified Audit Log |

**Records management lifecycle at Crestline Retail Group:**

```text
Content Created / Uploaded
         ↓
Auto-label applied (SIT or keyword classifier) — OR — User manually applies label
         ↓
Content becomes a Record (Financial or HR)
         ↓
Immutable during retention period (7 years)
         ↓
Retention period expires
         ↓
Disposition review triggered (if configured) — OR — Automatic deletion
         ↓
Deleted with deletion audit record preserved
```

**Disposition review process:**

For Financial Records and HR Records, a disposition review is configured to notify the IT administrator before deletion occurs. The administrator has 30 days to:

1. Approve deletion — item is permanently deleted and deletion is logged
2. Extend retention — additional retention period applied if ongoing legal or business need exists
3. Apply legal hold — item is preserved indefinitely pending legal proceedings

---

## Legal Hold Procedure

A legal hold in Microsoft Purview preserves all content for a custodian (user) or content location regardless of retention policies or deletion actions. Legal holds override all retention policies and prevent any deletion during the hold period.

**When to apply a legal hold at Crestline Retail Group:**

| Trigger | Action |
|---|---|
| Receipt of litigation hold notice | Apply legal hold immediately to named custodians |
| Employment dispute or wrongful dismissal claim | Apply legal hold to departing employee's mailbox and OneDrive |
| Regulatory investigation notice | Apply legal hold to all relevant content locations |
| HR investigation involving potential misconduct | Apply legal hold in coordination with HR (IRM escalation — Phase 9) |
| Vendor dispute involving documented communications | Apply legal hold to relevant mailboxes and SharePoint sites |

**Legal hold configuration steps in Microsoft Purview:**

1. Navigate to `Microsoft Purview compliance portal → eDiscovery → Core eDiscovery`
2. Select `Create a case` — name the case with the format `LegalHold-[Reference]-[Date]`
3. Add the case to the `Holds` tab
4. Configure the hold:
   - **Custodians:** Add the user(s) whose content must be preserved
   - **Locations:** Select Exchange mailbox, OneDrive account, and any SharePoint sites they have access to
   - **Query-based hold (optional):** Add keyword or date filters if the scope is known
5. Save the hold — Purview immediately begins preserving all content for the named locations
6. Document the hold details in the incident or legal record:
   - Case name and ID
   - Hold name and ID
   - Custodians covered
   - Content locations covered
   - Date hold applied
   - Reference to legal notice or HR trigger
7. Notify HR and/or legal counsel that the hold is active
8. To release the hold: navigate to the hold, select `Turn off` — only release after written confirmation from legal counsel or HR that the legal obligation has ended

---

## Configuration Steps in Microsoft Purview Compliance Portal

### Step 1 — Create Retention Policies

```text
Navigation: Microsoft Purview compliance portal
           → Data lifecycle management
           → Microsoft 365
           → Retention policies
           → New retention policy
```

For each policy in the taxonomy:

1. Enter the policy name (e.g., `CrestlineRetailGroup-Exchange-7Year-Retention`)
2. Select the workload locations to include
3. Set retention period and action (retain + delete)
4. Set the retention trigger (creation or last modification)
5. Review and submit — policy begins applying within 7 days for large location sets

---

### Step 2 — Create Retention Labels

```text
Navigation: Microsoft Purview compliance portal
           → Data lifecycle management
           → Microsoft 365
           → Labels
           → Retention labels
           → Create a label
```

For each label in the hierarchy:

1. Enter label name (e.g., `Financial Records`)
2. Configure retention settings (period, action, trigger)
3. For Financial Records and HR Records: enable `Mark items as a record`
4. Configure disposition review if required
5. Save label

---

### Step 3 — Publish Labels to Locations

```text
Navigation: Microsoft Purview compliance portal
           → Data lifecycle management
           → Microsoft 365
           → Label policies
           → Publish labels
```

1. Select all 5 retention labels
2. Publish to:
   - Exchange Online (all mailboxes)
   - SharePoint Online (all sites)
   - OneDrive for Business (all accounts)
3. Name the label policy: `CrestlineRetailGroup-RetentionLabels-AllLocations`
4. Labels appear in SharePoint and Outlook within 1–7 days

---

### Step 4 — Configure Auto-Apply Label Policies

```text
Navigation: Microsoft Purview compliance portal
           → Data lifecycle management
           → Microsoft 365
           → Label policies
           → Auto-apply a label
```

Configure auto-apply policies for Financial Records and HR Records using sensitive information types:

| Label | SIT Rule |
|---|---|
| `Financial Records` | Credit Card Number OR Canada Bank Account Number |
| `HR Records` | Canada Social Insurance Number OR Canada Passport Number |

Set confidence threshold to `High confidence` to minimize false-positive labeling.

---

## Archiving and Deletion Strategy

**Exchange Online archiving:**

The target state enables Exchange Online Archive for eligible mailboxes and applies an approved MRM policy for older content. Archive and primary mailbox retention would be validated together before broad rollout; no tenant-wide archive deployment is claimed here.

**SharePoint and OneDrive deletion:**

When a retention policy's retention period expires, content in SharePoint and OneDrive is moved to the `Preservation Hold Library` — a hidden, user-inaccessible library that preserves the content for the full retention period even if a user deletes the item. After the full retention period has elapsed, the content is permanently deleted and the deletion is recorded in the audit log.

**Teams message deletion:**

Teams messages subject to retention are preserved in the `SubstrateHolds` folder in the user's Exchange Online mailbox — invisible to users and inaccessible through Teams. After the retention period expires, messages are permanently deleted from this storage location.

**Deleted user accounts (departing employees):**

When an employee departs Crestline Retail Group:

1. The account is disabled in Entra ID (Phase 2 procedure)
2. The mailbox is converted to a shared mailbox or placed on litigation hold (if applicable)
3. The OneDrive account is assigned to the manager for 30-day review
4. After 30 days, the OneDrive is removed but Purview retention policies continue to preserve content in the Preservation Hold Library for the full retention period
5. HR Records and Financial Records labeled content is subject to the label's retention period regardless of account deletion

---

## PIPEDA Alignment Notes

PIPEDA (Personal Information Protection and Electronic Documents Act) establishes that personal information about Canadian individuals must be retained only as long as necessary for the identified purpose, and must be destroyed in a manner that prevents unauthorized access after its useful life.

**How this framework aligns to PIPEDA:**

| PIPEDA Principle | Framework Implementation |
|---|---|
| **Limiting collection** | Retention labels applied to SIT-detected personal information categorize and track personal data holdings |
| **Retention limitation** | Every workload policy and label has an explicit deletion action — no personal data is retained indefinitely |
| **Accuracy** | Retention periods align to the minimum required for the identified business or regulatory purpose |
| **Safeguarding** | Immutable record status for HR Records prevents tampering with personal information during its retention period |
| **Individual access** | Preserved content is locatable via eDiscovery for subject access requests |
| **Accountability** | Unified Audit Log captures all retention, labeling, and deletion activity for the full tenant |

**PIPEDA breach consideration:**

If a data breach occurs in the fictional environment, the framework is intended to improve evidence preservation and discovery. It does not guarantee that all personal data is labeled, located, or auditable without implementation testing and operational validation.

---

## Target-State Design Coverage

| Design area | Documented state |
|---|---|
| Retention policy taxonomy | Five workload policy categories documented |
| Retention label taxonomy | Five label categories mapped to business record types |
| Target scope | Fictional 300-user, six-site Microsoft 365 environment |
| Records controls | Immutable-record concepts documented for Financial and HR records |
| Legal preservation | Hold initiation, review, and release workflow documented |
| Auto-apply design | Two candidate label-policy patterns using sensitive information types |
| Production validation | Pending; deployment, coverage, and compliance outcomes are not claimed |

---

## Lab Environment Disclaimer

Crestline Retail Group is fictional. This target-state framework is documented for portfolio and lab-planning purposes; it does not claim production deployment, universal workload coverage, legal approval, or regulatory compliance. No actual employee records, customer personal information, financial data, or confidential business content is included.

---

## Skills Demonstrated

`Microsoft Purview` · `Retention Policies` · `Retention Labels` · `Records Management` · `Legal Hold` · `Data Lifecycle Governance` · `PIPEDA Compliance` · `Exchange Online Archiving` · `SharePoint Governance` · `Microsoft Teams Retention` · `eDiscovery` · `Auto-Apply Labels` · `Disposition Review` · `Compliance Administration`

---

Built by **Md Rahat Islam Anik**
Microsoft 365 Security Operations Portfolio · Phase 10
