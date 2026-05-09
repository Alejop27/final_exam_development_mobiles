// src/lib/upload.ts
// Configuración de Multer para subir la foto de perfil en /api/auth/register.

import multer, { FileFilterCallback } from 'multer';
import { Request } from 'express';
import { existsSync, mkdirSync } from 'node:fs';
import { resolve, extname } from 'node:path';
import { randomBytes } from 'node:crypto';
import { env } from '../config/env';
import { HttpErrors } from '../middleware/error.middleware';

const UPLOAD_PATH = resolve(env.UPLOAD_DIR);

if (!existsSync(UPLOAD_PATH)) {
    mkdirSync(UPLOAD_PATH, { recursive: true });
}

const ALLOWED_MIME = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
const MAX_SIZE_BYTES = 5 * 1024 * 1024; // 5 MB

const storage = multer.diskStorage({
    destination: (_req, _file, cb) => cb(null, UPLOAD_PATH),
    filename: (_req, file, cb) => {
        const id = randomBytes(12).toString('hex');
        const ext = extname(file.originalname).toLowerCase() || '.jpg';
        cb(null, `${id}${ext}`);
    },
});

function fileFilter(_req: Request, file: Express.Multer.File, cb: FileFilterCallback) {
    if (!ALLOWED_MIME.includes(file.mimetype)) {
        return cb(HttpErrors.badRequest(
            `Formato de imagen no soportado: ${file.mimetype}. Solo JPG/PNG/WEBP/GIF.`,
            'INVALID_IMAGE_TYPE',
        ));
    }
    cb(null, true);
}

export const uploadPhoto = multer({
    storage,
    fileFilter,
    limits: { fileSize: MAX_SIZE_BYTES },
});

export function buildPhotoUrl(filename: string | null | undefined): string | null {
    if (!filename) return null;
    return `${env.PUBLIC_URL}/uploads/${filename}`;
}