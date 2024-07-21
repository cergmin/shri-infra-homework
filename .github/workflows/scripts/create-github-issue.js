import { execSync } from 'child_process';

const releaseVersion = process.env.RELEASE_VERSION;
const fixVersion = `${releaseVersion}_fix${process.env.GITHUB_RUN_NUMBER}`;
const actor = process.env.GITHUB_ACTOR;
const registryId = process.env.REGISTRY_ID;
const githubToken = process.env.GITHUB_TOKEN;

const date = new Date().toISOString().split('T')[0];
const commits = process.env.COMMITS;

const issueBody = `
    **Date:** ${date}
    **Author:** ${actor}
    **Version:** ${fixVersion}
    **Commits:** ${commits}
    **Docker Image:** cr.yandex/${registryId}/app:${fixVersion}
`;

execSync(
  `curl -X POST -H "Authorization: token ${githubToken}" -H 
    "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${
      process.env.GITHUB_REPOSITORY
    }/issues -d '{"title": "Release fix ${fixVersion}",
    "body": "${issueBody.replace(/\n/g, '\\n')}"}'`
);
