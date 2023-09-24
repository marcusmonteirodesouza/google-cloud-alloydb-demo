import {app} from './app';
import {db} from './db';
import {logger} from './logger';
import {config} from './config';

app.listen(config.port, async () => {
  await db.migrate.latest();

  logger.info(
    {},
    `Google AlloyDB demo API server listening on port ${config.port}...`
  );
});
