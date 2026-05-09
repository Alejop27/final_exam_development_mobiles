// src/controllers/auth.controller.ts
// Controllers de autenticación.

import { Request, Response } from 'express';
import { authService } from '../services/auth.service';
import { buildPhotoUrl } from '../lib/upload';
import { HttpErrors } from '../middleware/error.middleware';
import type { RegisterInput, LoginInput, LogoutInput } from '../schemas/auth.schema';

export class AuthController {
    async register(req: Request, res: Response): Promise<void> {
        const input = req.body as RegisterInput;
        const photoUrl = buildPhotoUrl(req.file?.filename);

        if (!photoUrl) {
            throw HttpErrors.badRequest(
                'La foto de perfil es obligatoria',
                'PHOTO_REQUIRED',
            );
        }

        const result = await authService.register(input, photoUrl);
        res.status(201).json(result);
    }

    async login(req: Request, res: Response): Promise<void> {
        const input = req.body as LoginInput;
        const result = await authService.login(input);
        res.status(200).json(result);
    }

    async logout(req: Request, res: Response): Promise<void> {
        const input = req.body as LogoutInput;
        const requesterEmail = req.user!.email;
        await authService.logout(input, requesterEmail);
        res.status(204).send();
    }
}

export const authController = new AuthController();