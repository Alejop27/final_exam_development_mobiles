// src/middleware/validate.middleware.ts
// Middleware genérico de validación con Zod.

import { Request, Response, NextFunction } from 'express';
import { ZodSchema } from 'zod';

type Source = 'body' | 'query' | 'params';

export function validate(schema: ZodSchema, source: Source = 'body') {
    return (req: Request, _res: Response, next: NextFunction) => {
        try {
            const data = schema.parse(req[source]);

            if (source === 'body') {
                req.body = data;
            } else if (source === 'query') {
                Object.defineProperty(req, 'query', { value: data, writable: true });
            } else {
                Object.defineProperty(req, 'params', { value: data, writable: true });
            }

            next();
        } catch (err) {
            next(err);
        }
    };
}