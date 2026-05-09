// src/app.ts
// Configuración de la aplicación Express.

import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import path from 'node:path';
import { env, isDev } from './config/env';
import { errorMiddleware } from './middleware/error.middleware';
import { checkDatabaseConnection } from './lib/prisma';
import { isFirebaseInitialized } from './config/firebase';
import { logger } from './lib/logger';
import { apiRouter } from './routes';

export function createApp(): Application {
    const app = express();

    // Seguridad y middleware base
    app.use(helmet({ crossOriginResourcePolicy: { policy: 'cross-origin' } }));
    app.use(
        cors({
            origin: isDev ? '*' : [env.PUBLIC_URL],
            credentials: true,
        }),
    );
    app.use(express.json({ limit: '5mb' }));
    app.use(express.urlencoded({ extended: true }));

    if (isDev) {
        app.use(
            morgan('dev', {
                stream: { write: (msg) => logger.info(msg.trim()) },
            }),
        );
    }

    // Servir archivos estáticos (fotos de perfil)
    app.use('/uploads', express.static(path.resolve(env.UPLOAD_DIR)));

    // Health check
    app.get('/api/health', async (_req: Request, res: Response) => {
        const dbOk = await checkDatabaseConnection();
        const fbOk = isFirebaseInitialized();
        const status = dbOk && fbOk ? 'ok' : 'degraded';
        res.status(status === 'ok' ? 200 : 503).json({
            status,
            timestamp: new Date().toISOString(),
            services: {
                database: dbOk ? 'up' : 'down',
                firebase: fbOk ? 'up' : 'down',
            },
            env: env.NODE_ENV,
        });
    });

    // Raíz
    app.get('/', (_req, res) => {
        res.json({
            name: 'Mensajería Corporativa API',
            version: '1.0.0',
            docs: '/api/health',
        });
    });

    // API
    app.use('/api', apiRouter);

    // 404
    app.use((req, res) => {
        res.status(404).json({
            error: {
                message: `Ruta no encontrada: ${req.method} ${req.path}`,
                code: 'NOT_FOUND',
            },
        });
    });

    // Error handler
    app.use(errorMiddleware);

    return app;
}