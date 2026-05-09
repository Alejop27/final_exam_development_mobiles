// src/config/env.ts
// Validación centralizada de variables de entorno.
// Si falta o está mal una variable, el proceso termina ANTES de levantar el servidor.

import { config as loadDotenv } from 'dotenv';
import { z } from 'zod';

loadDotenv();

const envSchema = z.object({
    NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
    PORT: z.coerce.number().int().positive().default(3000),

    DATABASE_URL: z
        .string()
        .min(1, 'DATABASE_URL es obligatoria')
        .startsWith('postgresql://', 'DATABASE_URL debe empezar con postgresql://'),

    JWT_SECRET: z
        .string()
        .min(32, 'JWT_SECRET debe tener al menos 32 caracteres por seguridad'),
    JWT_EXPIRES_IN: z.string().default('7d'),

    FIREBASE_SERVICE_ACCOUNT_PATH: z
        .string()
        .min(1, 'FIREBASE_SERVICE_ACCOUNT_PATH es obligatoria'),

    UPLOAD_DIR: z.string().default('./uploads'),
    PUBLIC_URL: z.string().url('PUBLIC_URL debe ser una URL válida'),
});

export type Env = z.infer<typeof envSchema>;

function loadEnv(): Env {
    const parsed = envSchema.safeParse(process.env);

    if (!parsed.success) {
        console.error('\n Error en variables de entorno:\n');
        parsed.error.errors.forEach((err) => {
            console.error(`  • ${err.path.join('.')}: ${err.message}`);
        });
        console.error('\nRevisa tu archivo .env y compáralo con .env.example\n');
        process.exit(1);
    }

    return parsed.data;
}

export const env = loadEnv();
export const isDev = env.NODE_ENV === 'development';
export const isProd = env.NODE_ENV === 'production';