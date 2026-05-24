// Enterprise IT Security Operations Toolkit
// Dashboard — Static Metrics (GitHub Pages compatible)
// Author: Md Rahat Islam Anik

const platformMetrics = {
  totalScripts: 19,
  phases: 3,
  reportTypes: 11,
  labUsers: 28,
  secureScore: "146.26 / 204",
  technologies: 14
};

function renderMetrics() {
  const metricsEl = document.getElementById('platformMetrics');
  if (!metricsEl) return;

  metricsEl.innerHTML = `
    <div class="metric-card">
      <span class="metric-value">${platformMetrics.totalScripts}</span>
      <span class="metric-label">PowerShell Scripts</span>
    </div>
    <div class="metric-card">
      <span class="metric-value">${platformMetrics.phases}</span>
      <span class="metric-label">Operational Phases</span>
    </div>
    <div class="metric-card">
      <span class="metric-value">${platformMetrics.reportTypes}</span>
      <span class="metric-label">Report Types</span>
    </div>
    <div class="metric-card">
      <span class="metric-value">${platformMetrics.secureScore}</span>
      <span class="metric-label">Lab Secure Score</span>
    </div>
  `;
}

document.addEventListener('DOMContentLoaded', renderMetrics);
