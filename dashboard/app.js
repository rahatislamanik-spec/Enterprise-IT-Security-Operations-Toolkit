async function loadGitHubMetrics() {
    try {
        const response = await fetch('../data/github/github_metrics.json');
        const data = await response.json();

        document.getElementById('repoCount').innerText =
            `Total Repositories: ${data.totalReposTracked}`;

        document.getElementById('cloneCount').innerText =
            `Total Clones: ${data.totalClones}`;

        document.getElementById('uniqueCloners').innerText =
            `Unique Cloners: ${data.uniqueCloners}`;

        document.getElementById('topRepo').innerText =
            `Top Repo: ${data.topRepo}`;

        document.getElementById('lastUpdated').innerText =
            `Last Updated: ${data.lastUpdated}`;

    } catch (error) {
        console.error('Error loading GitHub metrics:', error);
    }
}

async function loadTrafficLeaderboard() {
    try {
        const response = await fetch('../data/github/repo_traffic_report.json');
        const repos = await response.json();

        const leaderboard = document.getElementById('leaderboard');

        repos.sort((a, b) => b.clones - a.clones);

        repos.forEach(repo => {
            const item = document.createElement('div');

            item.classList.add('leaderboard-item');

            item.innerHTML = `
                <h3>${repo.name}</h3>
                <p>Views: ${repo.views}</p>
                <p>Clones: ${repo.clones}</p>
                <p>Unique Cloners: ${repo.uniqueCloners}</p>
            `;

            leaderboard.appendChild(item);
        });

    } catch (error) {
        console.error('Error loading traffic leaderboard:', error);
    }
}

loadGitHubMetrics();
loadTrafficLeaderboard();