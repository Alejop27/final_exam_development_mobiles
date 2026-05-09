// src/lib/bcrypt.ts
// Helpers de hashing de contraseñas con bcrypt.

import bcrypt from 'bcrypt';

const SALT_ROUNDS = 10;

export async function hashPassword(plain: string): Promise<string> {
    if (!plain) {
        throw new Error('Cannot hash empty password');
    }
    return bcrypt.hash(plain, SALT_ROUNDS);
}

export async function verifyPassword(plain: string, hash: string): Promise<boolean> {
    if (!plain || !hash) return false;
    return bcrypt.compare(plain, hash);
}