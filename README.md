<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Enterprise IT Security Operations Toolkit</title>

  <style>
    :root{
      --bg:#07111f;
      --panel:#0f1b2d;
      --panel2:#13233a;
      --text:#f5f7fb;
      --muted:#a9b6c9;
      --line:rgba(255,255,255,0.08);
      --blue:#4ea8ff;
      --green:#4ade80;
      --purple:#8b5cf6;
      --gold:#facc15;
    }

    *{
      margin:0;
      padding:0;
      box-sizing:border-box;
    }

    body{
      font-family: Inter, -apple-system, BlinkMacSystemFont, sans-serif;
      background:
        radial-gradient(circle at top left, rgba(78,168,255,0.16), transparent 30%),
        radial-gradient(circle at top right, rgba(139,92,246,0.18), transparent 30%),
        linear-gradient(180deg,#07111f,#030712);
      color:var(--text);
      line-height:1.7;
    }

    nav{
      position:sticky;
      top:0;
      z-index:100;
      backdrop-filter: blur(18px);
      background:rgba(7,17,31,0.85);
      border-bottom:1px solid var(--line);
      padding:18px 7%;
      display:flex;
      justify-content:space-between;
      align-items:center;
    }

    nav strong{
      font-size:1rem;
    }

    nav span{
      color:var(--blue);
    }

    header{
      padding:90px 7% 70px;
      max-width:1300px;
      margin:auto;
    }

    .badge{
      display:inline-block;
      padding:8px 14px;
      border-radius:999px;
      border:1px solid rgba(78,168,255,0.25);
      background:rgba(78,168,255,0.08);
      color:var(--blue);
      font-weight:700;
      margin-bottom:24px;
    }

    h1{
      font-size:clamp(3rem,8vw,6rem);
      line-height:0.95;
      letter-spacing:-0.06em;
      max-width:950px;
    }

    .gradient{
      background:linear-gradient(90deg,#ffffff,#8bd0ff,#c5b4ff);
      -webkit-background-clip:text;
      color:transparent;
    }

    .lead{
      margin-top:28px;
      color:var(--muted);
      max-width:850px;
      font-size:1.15rem;
    }

    .hero-grid{
      margin-top:50px;
      display:grid;
      grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
      gap:18px;
    }

    .card{
      background:rgba(15,27,45,0.82);
      border:1px solid var(--line);
      border-radius:24px;
      padding:24px;
      backdrop-filter:blur(14px);
    }

    .card h3{
      margin-bottom:12px;
      font-size:1.1rem;
    }

    .card p{
      color:var(--muted);
      font-size:0.96rem;
    }

    section{
      padding:65px 7%;
      max-width:1300px;
      margin:auto;
    }

    .section-label{
      color:var(--green);
      text-transform:uppercase;
      letter-spacing:0.16em;
      font-size:0.8rem;
      font-weight:800;
      margin-bottom:12px;
    }

    h2{
      font-size:clamp(2rem,5vw,3.5rem);
      line-height:1.05;
      letter-spacing:-0.04em;
      margin-bottom:18px;
    }

    .section-text{
      color:var(--muted);
      max-width:900px;
      margin-bottom:36px;
    }

    .two-col{
      display:grid;
      grid-template-columns:repeat(auto-fit,minmax(320px,1fr));
      gap:24px;
    }

    ul{
      padding-left:20px;
    }

    li{
      margin-bottom:12px;
      color:var(--muted);
    }

    .architecture{
      background:rgba(255,255,255,0.04);
      border:1px solid var(--line);
      border-radius:24px;
      padding:40px;
      overflow:auto;
    }

    .flow{
      text-align:center;
      font-family:monospace;
      color:#dce8ff;
      font-size:1rem;
      white-space:pre-line;
      line-height:2;
    }

    .phase-grid{
      display:grid;
      grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
      gap:20px;
      margin-top:30px;
    }

    .phase{
      border-left:4px solid var(--blue);
      background:rgba(255,255,255,0.04);
      padding:24px;
      border-radius:18px;
    }

    .phase h3{
      margin-bottom:14px;
    }

    .screenshots{
      display:grid;
      grid-template-columns:repeat(auto-fit,minmax(320px,1fr));
      gap:22px;
      margin-top:28px;
    }

    .screenshots img{
      width:100%;
      border-radius:18px;
      border:1px solid var(--line);
      background:#000;
    }

    .caption{
      margin-top:10px;
      color:var(--muted);
      font-size:0.92rem;
    }

    footer{
      padding:70px 7%;
      text-align:center;
      color:var(--muted);
      border-top:1px solid var(--line);
      margin-top:60px;
    }

    .highlight{
      color:var(--gold);
      font-weight:700;
    }

    @media(max-width:700px){
      h1{
        line-height:1;
      }
    }
  </style>
</head>

<body>

  <nav>
    <strong>Enterprise IT <span>Security Operations Toolkit</span></strong>
  </nav>

  <header>

    <div class="badge">
      Phase 1 • Enterprise Operations Foundation
    </div>

    <h1>
      Enterprise Microsoft 365
      <span class="gradient">
        Security Operations
      </span>
      & Automation Platform
    </h1>

    <p class="lead">
      Enterprise-focused Microsoft 365 administration, governance, identity security,
      operational reporting, and PowerShell automation platform built using
      Microsoft Graph, Entra ID, and security operations workflows.
    </p>

    <div class="hero-grid">

      <div class="card">
        <h3>PowerShell Automation</h3>
        <p>
          Centralized reporting workflows designed to reduce repetitive manual administration tasks across Microsoft 365 environments.
        </p>
      </div>

      <div class="card">
        <h3>Operational Reporting</h3>
        <p>
          MFA audits, privileged access analysis, Conditional Access visibility, device compliance, and governance reporting.
        </p>
      </div>

      <div class="card">
        <h3>Enterprise Security</h3>
        <p>
          Simulated Tier 2 / Tier 3 enterprise operations workflows focused on governance, visibility, compliance, and operational scalability.
        </p>
      </div>

    </div>

  </header>

  <section>

    <div class="section-label">Project Overview</div>

    <h2>
      Why This Toolkit Was Built
    </h2>

    <p class="section-text">
      Microsoft 365 administration often requires navigating multiple admin portals,
      manually reviewing configurations, generating repetitive reports,
      validating governance controls, and managing operational visibility across large environments.
    </p>

    <div class="two-col">

      <div class="card">
        <h3>Operational Challenges</h3>

        <ul>
          <li>Manual tenant-wide administrative reviews</li>
          <li>Fragmented operational visibility</li>
          <li>Time-consuming governance reporting</li>
          <li>Privileged access auditing complexity</li>
          <li>Inconsistent compliance review workflows</li>
          <li>Repetitive administrative tasks</li>
        </ul>
      </div>

      <div class="card">
        <h3>Operational Goals</h3>

        <ul>
          <li>Reduce manual audit and reporting time</li>
          <li>Automate repetitive operational workflows</li>
          <li>Enable centralized reporting visibility</li>
          <li>Improve governance consistency</li>
          <li>Support scalable administrative operations</li>
          <li>Improve operational efficiency using automation</li>
        </ul>

      </div>

    </div>

  </section>

  <section>

    <div class="section-label">Architecture</div>

    <h2>
      Automation & Reporting Workflow
    </h2>

    <div class="architecture">

      <div class="flow">
Microsoft 365 Tenant
        ↓
Microsoft Graph API
        ↓
PowerShell Automation Layer
        ↓
Security & Governance Reporting
        ↓
CSV / TXT Operational Reports
        ↓
HTML Dashboard & Visualization
        ↓
GitHub Operations Platform
      </div>

    </div>

  </section>

  <section>

    <div class="section-label">Phase 1</div>

    <h2>
      Enterprise Operations Foundation
    </h2>

    <p class="section-text">
      Phase 1 focuses on operational visibility, governance reporting,
      PowerShell automation, Microsoft Graph integrations,
      and enterprise administration workflows.
    </p>

    <div class="phase-grid">

      <div class="phase">
        <h3>Tenant Health Reporting</h3>
        <p class="caption">
          Tenant inventory analysis, administrative visibility, user reporting, and governance visibility.
        </p>
      </div>

      <div class="phase">
        <h3>MFA Coverage Auditing</h3>
        <p class="caption">
          Authentication posture analysis and non-compliant user visibility reporting.
        </p>
      </div>

      <div class="phase">
        <h3>Admin Role Reviews</h3>
        <p class="caption">
          RBAC visibility, privileged access auditing, and governance analysis.
        </p>
      </div>

      <div class="phase">
        <h3>Conditional Access Visibility</h3>
        <p class="caption">
          Zero Trust policy visibility and operational policy auditing.
        </p>
      </div>

      <div class="phase">
        <h3>Device Compliance Reporting</h3>
        <p class="caption">
          Endpoint visibility, operating system reporting, and compliance tracking.
        </p>
      </div>

      <div class="phase">
        <h3>License Optimization</h3>
        <p class="caption">
          Inactive licensed accounts, optimization opportunities, and governance reviews.
        </p>
      </div>

    </div>

  </section>

  <section>

    <div class="section-label">Operational Benefits</div>

    <h2>
      Administrative & Business Impact
    </h2>

    <div class="two-col">

      <div class="card">
        <h3>Operational Improvements</h3>

        <ul>
          <li>Reduced manual reporting effort</li>
          <li>Faster tenant-wide visibility reviews</li>
          <li>Bulk operational analysis capabilities</li>
          <li>Centralized reporting workflows</li>
          <li>Improved governance consistency</li>
          <li>Repeatable operational processes</li>
        </ul>

      </div>

      <div class="card">
        <h3>Security & Governance Focus</h3>

        <ul>
          <li>Identity governance</li>
          <li>Privileged access visibility</li>
          <li>Compliance reporting</li>
          <li>Operational security visibility</li>
          <li>Administrative exposure analysis</li>
          <li>Security operations workflows</li>
        </ul>

      </div>

    </div>

  </section>

  <section>

    <div class="section-label">Screenshots</div>

    <h2>
      Operational Reporting Evidence
    </h2>

    <p class="section-text">
      Sample screenshots generated from isolated Microsoft 365 E3 and E5 lab environments used exclusively for testing, learning, automation development, and reporting simulation purposes.
    </p>

    <div class="screenshots">

      <div>
        <img src="screenshots/Screenshot 2026-05-23 at 10.16.40ΓÇ╗PM.png" alt="MFA Coverage Report">
        <div class="caption">MFA Coverage Audit Reporting</div>
      </div>

      <div>
        <img src="screenshots/Screenshot 2026-05-23 at 10.21.01ΓÇ╗PM.png" alt="Admin Role Audit">
        <div class="caption">Privileged Access & RBAC Visibility</div>
      </div>

      <div>
        <img src="screenshots/Screenshot 2026-05-23 at 10.35.21ΓÇ╗PM.png" alt="Conditional Access">
        <div class="caption">Conditional Access Operational Reporting</div>
      </div>

    </div>

  </section>

  <section>

    <div class="section-label">Future Roadmap</div>

    <h2>
      Planned Expansion Phases
    </h2>

    <div class="phase-grid">

      <div class="phase">
        <h3>Phase 2 — Security Operations</h3>
        <p class="caption">
          Defender integrations, risky users, insider risk, threat analytics, SIEM concepts, and sign-in risk reporting.
        </p>
      </div>

      <div class="phase">
        <h3>Phase 3 — Endpoint Security</h3>
        <p class="caption">
          Intune governance, macOS auditing, endpoint compliance, Defender for Endpoint, and device security workflows.
        </p>
      </div>

      <div class="phase">
        <h3>Phase 4 — Automation Platform</h3>
        <p class="caption">
          GitHub Actions automation, scheduled reporting pipelines, report orchestration, and dashboard automation.
        </p>
      </div>

      <div class="phase">
        <h3>Phase 5 — Executive Reporting</h3>
        <p class="caption">
          Secure Score dashboards, KPI metrics, governance analytics, operational reporting trends, and Power BI style executive views.
        </p>
      </div>

    </div>

  </section>

  <section>

    <div class="section-label">Environment Disclaimer</div>

    <h2>
      Controlled Lab Environment
    </h2>

    <div class="card">

      <p class="section-text">
        This project was developed using isolated Microsoft 365 E3 and E5 lab environments created exclusively for testing, learning, reporting simulation, automation development, and portfolio demonstration purposes.
      </p>

      <p class="section-text">
        All reports, screenshots, identities, devices, and operational data contained within this repository are generated from non-production lab tenants.
      </p>

      <p class="section-text">
        <span class="highlight">
          No real-world organizational infrastructure, confidential business information, customer records, or production tenant data are included or exposed in this repository.
        </span>
      </p>

    </div>

  </section>

  <footer>

    <h3>Md Rahat Islam Anik</h3>

    <p style="margin-top:12px;">
      Enterprise IT • Microsoft 365 • Identity Security • Cloud Operations • PowerShell Automation
    </p>

  </footer>

</body>
</html>