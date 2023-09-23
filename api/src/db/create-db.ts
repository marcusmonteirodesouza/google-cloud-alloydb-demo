import knex from 'knex';
import {config} from '../config';
import {logger} from '../logger';

async function createDB() {
  const db = knex({
    client: 'pg',
    connection: {
      host: config.database.host,
      port: config.database.port,
      user: config.database.username,
      password: config.database.password,
    },
  });

  try {
    await db.raw('CREATE DATABASE ??', config.database.name);
    logger.info(`Database ${config.database.name} created!`);
  } catch (err) {
    if (err instanceof Error) {
      if (!err.message.includes('already exists')) {
        throw err;
      }
    } else {
      logger.error(err);
      throw err;
    }
  }

  await db.destroy();
}

export {createDB};
