// src/routes/message.routes.ts
// Rutas de mensajería. Todas requieren autenticación.

import { Router } from 'express';
import { messageController } from '../controllers/message.controller';
import { authMiddleware } from '../middleware/auth.middleware';
import { validate } from '../middleware/validate.middleware';
import {
    sendMessageSchema,
    inboxQuerySchema,
} from '../schemas/message.schema';
import { asyncHandler } from '../middleware/error.middleware';

const router = Router();

// Todas las rutas requieren JWT
router.use(authMiddleware);

/** POST /api/messages — enviar mensaje + push */
router.post(
    '/',
    validate(sendMessageSchema),
    asyncHandler(messageController.send.bind(messageController)),
);

/** GET /api/messages/inbox — bandeja de recibidos */
router.get(
    '/inbox',
    validate(inboxQuerySchema, 'query'),
    asyncHandler(messageController.inbox.bind(messageController)),
);

/** GET /api/messages/sent — mensajes enviados */
router.get(
    '/sent',
    validate(inboxQuerySchema, 'query'),
    asyncHandler(messageController.sent.bind(messageController)),
);

export { router as messageRoutes };