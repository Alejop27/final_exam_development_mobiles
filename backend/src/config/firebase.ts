// src/config/firebase.ts
// Inicialización de Firebase Admin SDK.
// Lee el service-account JSON desde la ruta indicada en .env.

import { existsSync, readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import admin from 'firebase-admin';
import { env } from './env';
import { logger } from '../lib/logger';

let initialized = false;

export function initializeFirebase(): admin.app.App {
    if (initialized) {
        return admin.app();
    }

    const accountPath = resolve(env.FIREBASE_SERVICE_ACCOUNT_PATH);

    if (!existsSync(accountPath)) {
        throw new Error(
            `firebase-service-account.json no encontrado en: ${accountPath}\n` +
            `Descárgalo desde Firebase Console > Configuración del proyecto > ` +
            `Cuentas de servicio > Generar nueva clave privada.`,
        );
    }

    const raw = readFileSync(accountPath, 'utf-8');
    const serviceAccount = JSON.parse(raw);

    const app = admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
    });

    initialized = true;
    logger.info(
        { projectId: serviceAccount.project_id },
        'Firebase Admin initialized',
    );
    return app;
}

export function isFirebaseInitialized(): boolean {
    return initialized;
}