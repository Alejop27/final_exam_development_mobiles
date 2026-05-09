// src/middleware/error.middleware.ts
// Manejo centralizado de errores HTTP.

import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import { Prisma } from '@prisma/client';
import { JsonWebTokenError, TokenExpiredError } from 'jsonwebtoken';
import { logger } from '../lib/logger';
import { isProd } from '../config/env';

export class AppError extends Error {
    constructor(
        public readonly statusCode: number,
        message: string,
        public readonly code?: string,
        public readonly details?: unknown,
    ) {
        super(message);
        this.name = 'AppError';
        Error.captureStackTrace(this, this.constructor);
    }
}

export const HttpErrors = {
    badRequest: (msg: string, code?: string, details?: unknown) =>
        new AppError(400, msg, code, details),
    unauthorized: (msg = 'No autenticado', code?: string) =>
        new AppError(401, msg, code),
    forbidden: (msg = 'Sin permisos', code?: string) => new AppError(403, msg, code),
    notFound: (msg = 'Recurso no encontrado', code?: string) =>
        new AppError(404, msg, code),
    conflict: (msg: string, code?: string) => new AppError(409, msg, code),
    unprocessable: (msg: string, code?: string, details?: unknown) =>
        new AppError(422, msg, code, details),
    internal: (msg = 'Error interno') => new AppError(500, msg, 'INTERNAL_ERROR'),
};

export function errorMiddleware(
    err: unknown,
    _req: Request,
    res: Response,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _next: NextFunction,
) {
    if (err instanceof AppError) {
        return res.status(err.statusCode).json({
            error: {
                message: err.message,
                code: err.code,
                details: err.details,
            },
        });
    }

    if (err instanceof ZodError) {
        return res.status(422).json({
            error: {
                message: 'Datos de entrada inválidos',
                code: 'VALIDATION_ERROR',
                details: err.errors.map((e) => ({
                    path: e.path.join('.'),
                    message: e.message,
                })),
            },
        });
    }

    if (err instanceof TokenExpiredError) {
        return res.status(401).json({
            error: { message: 'Token expirado', code: 'TOKEN_EXPIRED' },
        });
    }
    if (err instanceof JsonWebTokenError) {
        return res.status(401).json({
            error: { message: 'Token inválido', code: 'INVALID_TOKEN' },
        });
    }

    if (err instanceof Prisma.PrismaClientKnownRequestError) {
        if (err.code === 'P2002') {
            const target = (err.meta?.target as string[] | undefined)?.join(', ') ?? 'campo';
            return res.status(409).json({
                error: {
                    message: `Ya existe un registro con ese ${target}`,
                    code: 'DUPLICATE_ENTRY',
                },
            });
        }
        if (err.code === 'P2025') {
            return res.status(404).json({
                error: { message: 'Registro no encontrado', code: 'NOT_FOUND' },
            });
        }
    }

    logger.error({ err }, 'Unhandled error');
    return res.status(500).json({
        error: {
            message: isProd ? 'Error interno del servidor' : String(err),
            code: 'INTERNAL_ERROR',
            ...(isProd ? {} : { stack: (err as Error).stack }),
        },
    });
}

export function asyncHandler<T extends Request, U extends Response>(
    fn: (req: T, res: U, next: NextFunction) => Promise<unknown>,
) {
    return (req: T, res: U, next: NextFunction) => {
        Promise.resolve(fn(req, res, next)).catch(next);
    };
}