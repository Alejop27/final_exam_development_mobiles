// src/server.ts
// Punto de entrada del servidor.

import { env } from './config/env';
import { logger } from './lib/logger';
import { checkDatabaseConnection, disconnectPrisma } from './lib/prisma';
import { initializeFirebase } from './config/firebase';
import { createApp } from './app';

async function bootstrap(): Promise<void> {
    logger.info(`Starting Mensajería Corporativa API in ${env.NODE_ENV} mode...`);

    // 1) Conexión a la base de datos
    const dbOk = await checkDatabaseConnection();
    if (!dbOk) {
        logger.fatal('Cannot connect to database. Check DATABASE_URL and that PostgreSQL is running.');
        process.exit(1);
    }
    logger.info('✓ Prisma connected to database');

    // 2) Firebase Admin
    try {
        initializeFirebase();
        logger.info('✓ Firebase Admin initialized');
    } catch (err) {
        logger.fatal({ err }, 'Failed to initialize Firebase Admin');
        process.exit(1);
    }

    // 3) Levantar Express
    const app = createApp();
    const server = app.listen(env.PORT, () => {
        logger.info(`🚀 Server running at http://localhost:${env.PORT}`);
        logger.info(`   Health check: http://localhost:${env.PORT}/api/health`);
    });

    // 4) Shutdown graceful
    const shutdown = async (signal: string): Promise<void> => {
        logger.info(`Received ${signal}. Shutting down gracefully...`);
        server.close(async () => {
            await disconnectPrisma();
            logger.info('Server closed. Bye 👋');
            process.exit(0);
        });

        setTimeout(() => {
            logger.error('Forcing shutdown after 10s');
            process.exit(1);
        }, 10_000);
    };

    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT', () => shutdown('SIGINT'));

    // 5) Último escudo
    process.on('unhandledRejection', (reason) => {
        logger.error({ reason }, 'Unhandled promise rejection');
    });
    process.on('uncaughtException', (err) => {
        logger.fatal({ err }, 'Uncaught exception. Exiting.');
        process.exit(1);
    });
}

bootstrap().catch((err) => {
    logger.fatal({ err }, 'Bootstrap failed');
    process.exit(1);
});