// src/lib/jwt.ts
// Emisión y verificación de JSON Web Tokens.

import jwt, { SignOptions, JwtPayload } from 'jsonwebtoken';
import { env } from '../config/env';

export interface AuthTokenPayload extends JwtPayload {
    email: string;
}

export function signAuthToken(payload: { email: string }): string {
    const options: SignOptions = {
        expiresIn: env.JWT_EXPIRES_IN as SignOptions['expiresIn'],
        issuer: 'mensajeria-corporativa',
    };
    return jwt.sign(payload, env.JWT_SECRET, options);
}

export function verifyAuthToken(token: string): AuthTokenPayload {
    const decoded = jwt.verify(token, env.JWT_SECRET, {
        issuer: 'mensajeria-corporativa',
    });

    if (typeof decoded === 'string') {
        throw new Error('Unexpected JWT payload format');
    }
    return decoded as AuthTokenPayload;
}