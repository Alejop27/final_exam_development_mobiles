// src/lib/prisma.ts
// Singleton de Prisma Client con guard contra hot-reload.

import { PrismaClient } from '@prisma/client';
import { logger } from './logger';
import { isDev } from '../config/env';

declare global {
    // eslint-disable-next-line no-var
    var __prismaClient: PrismaClient | undefined;
}

function createPrismaClient(): PrismaClient {
    return new PrismaClient({
        log: isDev
            ? [
                { emit: 'event', level: 'query' },
                { emit: 'event', level: 'warn' },
                { emit: 'event', level: 'error' },
            ]
            : [{ emit: 'event', level: 'error' }],
    });
}

export const prisma: PrismaClient = global.__prismaClient ?? createPrismaClient();

if (isDev) {
    global.__prismaClient = prisma;
}

// @ts-expect-error - Prisma's typed events vary; this is the documented runtime API
prisma.$on('query', (e: { query: string; duration: number }) => {
    logger.debug({ query: e.query, durationMs: e.duration }, 'Prisma query');
});

// @ts-expect-error - same as above
prisma.$on('error', (e: { message: string }) => {
    logger.error({ msg: e.message }, 'Prisma error');
});

export async function checkDatabaseConnection(): Promise<boolean> {
    try {
        await prisma.$queryRaw`SELECT 1`;
        return true;
    } catch (err) {
        logger.error({ err }, 'Database connection check failed');
        return false;
    }
}

export async function disconnectPrisma(): Promise<void> {
    await prisma.$disconnect();
    logger.info('Prisma disconnected');
}