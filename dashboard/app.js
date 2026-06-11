// Static evidence metrics for GitHub Pages. Update these when new phases or reports are added.
const toolkitMetrics = [
  { value: '9', label: 'Operational Phases' },
  { value: '30+', label: 'PowerShell Scripts' },
  { value: '25+', label: 'Reports and Evidence Files' },
  { value: '47', label: 'Curated Visual Assets' },
  { value: '146.26 / 204', label: 'Lab Secure Score Snapshot' },
  { value: '241', label: 'Service Principals Reviewed' },
  { value: '23', label: 'Exchange Mailboxes Audited' },
  { value: '3', label: 'High-Risk OAuth Grants Flagged' }
];

function renderMetrics() {
  const metricsElement = document.getElementById('platformMetrics');
  if (!metricsElement) return;

  metricsElement.innerHTML = toolkitMetrics.map((metric) => `
    <article class="metric-card">
      <strong>${metric.value}</strong>
      <span>${metric.label}</span>
    </article>
  `).join('');
}

document.addEventListener('DOMContentLoaded', renderMetrics);
