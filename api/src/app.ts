import express from 'express';
import crypto from 'crypto';
import cors from 'cors';
import pinoHttp from 'pino-http';
import helmet from 'helmet';
import {getConnection} from './db';
import {HealthCheckRouter} from './health-check';
import {errorHandler} from './error-handler';
import {logger} from './logger';
import {config} from './config';

function createApp() {
  const db = getConnection();

  const healthCheckRouter = new HealthCheckRouter({knex: db}).router;

  const app = express();

  app.use(helmet());

  app.use(cors());

  app.use(
    pinoHttp({
      logger,

      genReqId: function (req, res) {
        const existingId = req.id ?? req.headers['x-cloud-trace-context'];

        if (existingId) {
          return existingId;
        }

        // See https://cloud.google.com/trace/docs/setup#force-trace
        const traceId = crypto.randomBytes(16).toString('hex');
        const spanId = crypto.randomInt(1, 281474976710655);
        const id = `${traceId}/${spanId};o=1`;
        res.setHeader('x-cloud-trace-context', id);
        return id;
      },

      serializers: {
        req(req) {
          req.body = req.raw.body;
          return req;
        },
      },
    })
  );

  app.use('/v1', healthCheckRouter);

  app.use(express.json());

  app.use(
    async (
      err: Error,
      req: express.Request,
      res: express.Response,
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      _next: express.NextFunction
    ) => {
      await errorHandler.handleError(err, req, res);
    }
  );

  return {app, db};
}

export {createApp};
