import {Logger} from 'pino';

export {};

declare global {
  namespace Express {
    export interface Request {
      log: Logger;
    }
  }
}
