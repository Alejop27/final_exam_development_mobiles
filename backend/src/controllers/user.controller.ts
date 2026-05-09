// src/controllers/user.controller.ts
// Controllers de usuarios.

import { Request, Response } from 'express';
import { userService } from '../services/user.service';
import { z } from 'zod';

const emailParamSchema = z.object({
    email: z.string().toLowerCase().email(),
});

export class UserController {
    async listAll(req: Request, res: Response): Promise<void> {
        const requesterEmail = req.user!.email;
        const users = await userService.listAllExcept(requesterEmail);
        res.status(200).json({ users, total: users.length });
    }

    async getByEmail(req: Request, res: Response): Promise<void> {
        const { email } = emailParamSchema.parse({ email: req.params.email });
        const user = await userService.getByEmail(email);
        res.status(200).json({ user });
    }

    async getMe(req: Request, res: Response): Promise<void> {
        const requesterEmail = req.user!.email;
        const user = await userService.getByEmail(requesterEmail);
        res.status(200).json({ user });
    }
}

export const userController = new UserController();