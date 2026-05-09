// src/services/message.service.ts
// Servicio de mensajería: envío con notificaciones push y consultas de bandejas.

import { Message, PushDelivery } from '@prisma/client';
import { messageRepository } from '../repositories/message.repository';
import { userRepository } from '../repositories/user.repository';
import { deviceRepository } from '../repositories/device.repository';
import { sendPushToToken, FcmSendResult } from '../lib/fcm';
import { HttpErrors } from '../middleware/error.middleware';
import { logger } from '../lib/logger';
import type { SendMessageInput, InboxQuery } from '../schemas/message.schema';

// ───────────── DTOs públicos ─────────────

/** Vista pública de una entrega push (sin IDs internos sensibles). */
export interface PublicDelivery {
    fcmToken: string;
    success: boolean;
    errorCode: string | null;
    sentAt: Date;
}

/** Mini DTO de usuario embebido en mensajes (sin password ni datos sensibles). */
export interface MessageUserSummary {
    email: string;
    fullName: string;
    photoUrl: string | null;
    jobTitle: string;
}

/** Mensaje tal como lo verá la app. */
export interface PublicMessage {
    id: string;
    title: string;
    body: string;
    createdAt: Date;
    sender: MessageUserSummary;
    recipient: MessageUserSummary;
}

/** Respuesta al envío exitoso. */
export interface SendMessageResponse {
    message: PublicMessage;
    deliveries: PublicDelivery[];
    /** Resumen rápido para que la app muestre feedback. */
    summary: {
        devicesTargeted: number;
        devicesDelivered: number;
        devicesFailed: number;
    };
}

/** Respuesta paginada de bandejas. */
export interface PagedMessages {
    messages: PublicMessage[];
    pagination: {
        page: number;
        pageSize: number;
        total: number;
        totalPages: number;
    };
}

// ───────────── Mappers ─────────────

function toPublicDelivery(d: PushDelivery): PublicDelivery {
    return {
        fcmToken: d.fcmToken,
        success: d.success,
        errorCode: d.errorCode,
        sentAt: d.sentAt,
    };
}

function toMessageUserSummary(u: {
    email: string;
    fullName: string;
    photoUrl: string | null;
    jobTitle: string;
}): MessageUserSummary {
    return {
        email: u.email,
        fullName: u.fullName,
        photoUrl: u.photoUrl,
        jobTitle: u.jobTitle,
    };
}

// ───────────── Service ─────────────

export class MessageService {
    /**
     * CASO DE USO PRINCIPAL del examen:
     * 1. Validar que el destinatario existe.
     * 2. Validar que no es el mismo usuario.
     * 3. Persistir el mensaje (fuente de verdad).
     * 4. Buscar TODOS los dispositivos del destinatario.
     * 5. Enviar push a cada uno EN PARALELO.
     * 6. Persistir un PushDelivery por cada token (con respuesta cruda).
     * 7. Retornar el mensaje + entregas para feedback al cliente.
     */
    async sendMessage(
        input: SendMessageInput,
        senderEmail: string,
    ): Promise<SendMessageResponse> {
        // 1) Validar destinatario
        const recipient = await userRepository.findByEmail(input.recipientEmail);
        if (!recipient) {
            throw HttpErrors.notFound(
                'El destinatario no existe en el sistema',
                'RECIPIENT_NOT_FOUND',
            );
        }

        // 2) No permitir auto-mensajes
        if (recipient.email === senderEmail) {
            throw HttpErrors.badRequest(
                'No puedes enviarte mensajes a ti mismo',
                'SELF_MESSAGE_FORBIDDEN',
            );
        }

        // 3) Persistir el mensaje (fuente de verdad — independiente del éxito de la push)
        const message = await messageRepository.create({
            title: input.title,
            body: input.body,
            senderEmail,
            recipientEmail: recipient.email,
        });

        logger.info(
            { messageId: message.id, sender: senderEmail, recipient: recipient.email },
            'Message persisted',
        );

        // 4) Buscar dispositivos del destinatario
        const devices = await deviceRepository.findAllByUser(recipient.email);

        // 5 & 6) Si tiene dispositivos: envío + persistencia
        let deliveryRecords: PushDelivery[] = [];
        if (devices.length > 0) {
            // Enviar a todos en paralelo
            const fcmResults: FcmSendResult[] = await Promise.all(
                devices.map((device) =>
                    sendPushToToken({
                        fcmToken: device.fcmToken,
                        title: input.title,
                        body: input.body,
                        data: {
                            messageId: message.id,
                            senderEmail,
                            type: 'new_message',
                        },
                    }),
                ),
            );

            // Construir registros de entrega — uno por dispositivo
            const deliveriesData = devices.map((device, idx) => {
                const result = fcmResults[idx];
                return {
                    messageId: message.id,
                    deviceId: device.id,
                    fcmToken: device.fcmToken,
                    success: result.success,
                    fcmResponse: result.rawResponse as object,
                    errorCode: result.errorCode ?? null,
                };
            });

            // Persistir las entregas en batch
            await messageRepository.createDeliveries(deliveriesData);

            // Releer con las entregas creadas (para tener IDs y sentAt)
            const enriched = await messageRepository.findByIdWithDeliveries(message.id);
            deliveryRecords = enriched?.deliveries ?? [];

            logger.info(
                {
                    messageId: message.id,
                    targeted: devices.length,
                    delivered: fcmResults.filter((r) => r.success).length,
                    failed: fcmResults.filter((r) => !r.success).length,
                },
                'Push deliveries completed',
            );
        } else {
            logger.warn(
                { recipient: recipient.email, messageId: message.id },
                'Recipient has no registered devices — message saved but no push sent',
            );
        }

        // 7) Construir respuesta pública
        return {
            message: {
                id: message.id,
                title: message.title,
                body: message.body,
                createdAt: message.createdAt,
                sender: toMessageUserSummary({
                    email: senderEmail,
                    fullName: '', // No tenemos sender cargado aquí; la app ya lo conoce
                    photoUrl: null,
                    jobTitle: '',
                }),
                recipient: toMessageUserSummary(recipient),
            },
            deliveries: deliveryRecords.map(toPublicDelivery),
            summary: {
                devicesTargeted: devices.length,
                devicesDelivered: deliveryRecords.filter((d) => d.success).length,
                devicesFailed: deliveryRecords.filter((d) => !d.success).length,
            },
        };
    }

    /** Bandeja de entrada paginada. */
    async getInbox(userEmail: string, query: InboxQuery): Promise<PagedMessages> {
        const { page, pageSize } = query;
        const { messages, total } = await messageRepository.findInbox(
            userEmail,
            page,
            pageSize,
        );

        return {
            messages: messages.map((m) => ({
                id: m.id,
                title: m.title,
                body: m.body,
                createdAt: m.createdAt,
                sender: toMessageUserSummary(m.sender),
                recipient: toMessageUserSummary(m.recipient),
            })),
            pagination: {
                page,
                pageSize,
                total,
                totalPages: Math.ceil(total / pageSize),
            },
        };
    }

    /** Mensajes enviados (paginados). */
    async getSent(userEmail: string, query: InboxQuery): Promise<PagedMessages> {
        const { page, pageSize } = query;
        const { messages, total } = await messageRepository.findSent(
            userEmail,
            page,
            pageSize,
        );

        return {
            messages: messages.map((m) => ({
                id: m.id,
                title: m.title,
                body: m.body,
                createdAt: m.createdAt,
                sender: toMessageUserSummary(m.sender),
                recipient: toMessageUserSummary(m.recipient),
            })),
            pagination: {
                page,
                pageSize,
                total,
                totalPages: Math.ceil(total / pageSize),
            },
        };
    }
}

export const messageService = new MessageService();