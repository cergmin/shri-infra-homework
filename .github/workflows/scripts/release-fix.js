import { execSync } from 'child_process';

const oauthToken = process.env.OAUTH_TOKEN;
const runNumber = process.env.GITHUB_RUN_NUMBER;
const registryId = process.env.REGISTRY_ID;
const releaseVersion = process.env.RELEASE_VERSION;

execSync(`git checkout releases/${releaseVersion}`);

execSync(`npm install`);
execSync(`tsc --noEmit`);
execSync(`npm test`);

execSync(
  `echo ${oauthToken} | docker login --username oauth --password-stdin cr.yandex`
);

// Сборка Docker-образа
const fixVersion = `${releaseVersion}_fix${runNumber}`;
execSync(`docker build -t cr.yandex/${registryId}/app:${runNumber} .`);
execSync(
  `docker tag cr.yandex/${registryId}/app:${runNumber} cr.yandex/${registryId}/app:${runNumber}_latest`
);

// Загрузка Docker-образа в реестр
execSync(
  `echo "${process.env.REGISTRY_ACCESS_TOKEN}" | 
  docker login -u "${process.env.REGISTRY_USERNAME}" --password-stdin cr.your-cloud-service.com`
);
execSync(`docker push cr.yandex/${registryId}/app:${fixVersion}`);
execSync(`docker push cr.yandex/${registryId}/app:${releaseVersion}_latest`);

// Создание тега
execSync(`git tag -a ${fixVersion} -m "Release fix ${fixVersion}"`);
execSync(`git push origin ${fixVersion}`);
