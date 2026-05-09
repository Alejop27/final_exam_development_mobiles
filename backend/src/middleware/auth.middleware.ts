// src/middleware/auth.middleware.ts
// Middleware de autenticación JWT.

import { Request, Response, NextFunction } from 'express';
import { verifyAuthToken } from '../lib/jwt';
import { HttpErrors } from './error.middleware';

export function authMiddleware(
    req: Request,
    _res: Response,
    next: NextFunction,
): void {
    const header = req.headers.authorization;

    if (!header || !header.startsWith('Bearer ')) {
        return next(HttpErrors.unauthorized('Falta header Authorization Bearer'));
    }

    const token = header.slice('Bearer '.length).trim();
    if (!token) {
        return next(HttpErrors.unauthorized('Token vacío'));
    }

    try {
        const payload = verifyAuthToken(token);
        req.user = payload;
        next();
    } catch (err) {
        next(err);
    }
}