// src/types/express.d.ts
// Module augmentation: agrega `req.user` tipado al contexto de Express.

import { AuthTokenPayload } from '../lib/jwt';

declare global {
    namespace Express {
        interface Request {
            user?: AuthTokenPayload;
        }
    }
}

export { };