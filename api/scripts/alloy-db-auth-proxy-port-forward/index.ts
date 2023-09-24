import {execSync} from 'child_process';
import {config} from '../../src/config';

/**
 * See https://cloud.google.com/solutions/connecting-securely#port-forwarding-over-ssh
 */
async function run() {
  const command = `gcloud compute ssh ${config.allowDbProxy.vm.name} --project ${config.google.projectId} --zone ${config.allowDbProxy.vm.zone} -- -NL ${config.database.port}:localhost:${config.database.port}`;
  execSync(command, {stdio: 'inherit'});
}

run();
