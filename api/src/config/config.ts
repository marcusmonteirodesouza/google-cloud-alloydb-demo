import {Joi} from 'celebrate';

const envVarsSchema = Joi.object()
  .keys({
    ALLOYDB_AUTH_PROXY_VM_NAME: Joi.string(),
    ALLOYDB_AUTH_PROXY_VM_ZONE: Joi.string(),
    GOOGLE_PROJECT_ID: Joi.string().required(),
    K_REVISION: Joi.string().required(),
    K_SERVICE: Joi.string().required(),
    LOG_LEVEL: Joi.string().valid('debug', 'info').default('info'),
    NODE_ENV: Joi.string()
      .valid('development', 'test', 'production')
      .default('production'),
    PORT: Joi.number().integer().required(),
    PGHOST: Joi.string().required(),
    PGPORT: Joi.number().integer().required(),
    PGUSERNAME: Joi.string().required(),
    PGPASSWORD: Joi.string().required(),
    PGDATABASE: Joi.string().required(),
  })
  .unknown();

const {value: envVars, error} = envVarsSchema.validate(process.env);

if (error) {
  throw error;
}

const config = {
  allowDbProxy: {
    vm: {
      name: envVars.ALLOYDB_AUTH_PROXY_VM_NAME,
      zone: envVars.ALLOYDB_AUTH_PROXY_VM_ZONE,
    },
  },
  database: {
    host: envVars.PGHOST,
    port: envVars.PGPORT,
    username: envVars.PGUSERNAME,
    password: envVars.PGPASSWORD,
    name: envVars.PGDATABASE,
  },
  google: {
    cloudRun: {
      revision: envVars.K_REVISION,
      service: envVars.K_SERVICE,
    },
    projectId: envVars.GOOGLE_PROJECT_ID,
  },
  logLevel: envVars.LOG_LEVEL,
  port: envVars.PORT,
  nodeEnv: envVars.NODE_ENV,
};

export {config};
