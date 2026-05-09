// src/controllers/message.controller.ts
// Controllers de mensajería.

import { Request, Response } from 'express';
import { messageService } from '../services/message.service';
import type { SendMessageInput, InboxQuery } from '../schemas/message.schema';

export class MessageController {
    /**
     * POST /api/messages
     * Body JSON: { recipientEmail, title, body }
     * Auth: requerido. El sender se extrae del JWT.
     */
    async send(req: Request, res: Response): Promise<void> {
        const input = req.body as SendMessageInput;
        const senderEmail = req.user!.email;

        const result = await messageService.sendMessage(input, senderEmail);
        res.status(201).json(result);
    }

    /**
     * GET /api/messages/inbox?page=1&pageSize=20
     * Bandeja de mensajes recibidos del usuario autenticado.
     */
    async inbox(req: Request, res: Response): Promise<void> {
        const userEmail = req.user!.email;
        const query = req.query as unknown as InboxQuery;

        const result = await messageService.getInbox(userEmail, query);
        res.status(200).json(result);
    }

    /**
     * GET /api/messages/sent?page=1&pageSize=20
     * Mensajes enviados por el usuario autenticado.
     */
    async sent(req: Request, res: Response): Promise<void> {
        const userEmail = req.user!.email;
        const query = req.query as unknown as InboxQuery;

        const result = await messageService.getSent(userEmail, query);
        res.status(200).json(result);
    }
}

export const messageController = new MessageController();