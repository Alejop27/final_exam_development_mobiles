// src/schemas/message.schema.ts
// Validación Zod de los inputs de los endpoints de mensajería.

import { z } from 'zod';

// ───────────── Enviar mensaje ─────────────

export const sendMessageSchema = z.object({
    recipientEmail: z
        .string()
        .trim()
        .toLowerCase()
        .email('Email del destinatario inválido')
        .max(191, 'Email demasiado largo'),
    title: z
        .string()
        .trim()
        .min(1, 'El título es obligatorio')
        .max(200, 'El título no puede exceder 200 caracteres'),
    body: z
        .string()
        .trim()
        .min(1, 'El mensaje no puede estar vacío')
        .max(5000, 'El mensaje no puede exceder 5000 caracteres'),
});

export type SendMessageInput = z.infer<typeof sendMessageSchema>;

// ───────────── Paginación de bandejas ─────────────

export const inboxQuerySchema = z.object({
    page: z.coerce.number().int().positive().default(1),
    pageSize: z.coerce.number().int().positive().max(100).default(20),
});

export type InboxQuery = z.infer<typeof inboxQuerySchema>;