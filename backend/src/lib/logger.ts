// src/lib/logger.ts
// Logger centralizado basado en Pino.

import pino from 'pino';
import { env, isDev } from '../config/env';

export const logger = pino({
    level: isDev ? 'debug' : 'info',
    transport: isDev
        ? {
            target: 'pino-pretty',
            options: {
                colorize: true,
                translateTime: 'HH:MM:ss',
                ignore: 'pid,hostname',
            },
        }
        : undefined,
    redact: {
        paths: ['password', 'passwordHash', 'authorization', '*.password', '*.token'],
        censor: '[REDACTED]',
    },
    base: {
        env: env.NODE_ENV,
    },
});