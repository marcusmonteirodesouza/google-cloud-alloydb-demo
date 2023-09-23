import {createApp} from './app';
import {createDB} from './db';
import {logger} from './logger';
import {config} from './config';

async function startServer() {
  await createDB();

  const {app, db} = createApp();

  await db.migrate.latest();

  app.listen(config.port, () => {
    logger.info(
      {},
      `Google AlloyDB demo API server listening on port ${config.port}...`
    );
  });
}

startServer();
