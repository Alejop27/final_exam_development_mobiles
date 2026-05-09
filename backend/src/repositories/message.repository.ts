// src/repositories/message.repository.ts
// Repositorio de mensajes y entregas push.
// Maneja también la creación de PushDelivery (relación N:N con Device).

import { Message, PushDelivery, Prisma } from '@prisma/client';
import { prisma } from '../lib/prisma';

/** Mensaje con sus entregas push (para responses enriquecidas). */
export type MessageWithDeliveries = Message & {
    deliveries: PushDelivery[];
};

/** Mensaje con datos básicos del remitente/destinatario (para bandejas). */
export type MessageWithUsers = Message & {
    sender: {
        email: string;
        fullName: string;
        photoUrl: string | null;
        jobTitle: string;
    };
    recipient: {
        email: string;
        fullName: string;
        photoUrl: string | null;
        jobTitle: string;
    };
};

export class MessageRepository {
    /** Crea el mensaje y retorna su ID. Las deliveries se crean por separado. */
    async create(data: {
        title: string;
        body: string;
        senderEmail: string;
        recipientEmail: string;
    }): Promise<Message> {
        return prisma.message.create({ data });
    }

    /**
     * Crea múltiples PushDelivery en una sola operación.
     * createMany es atómico y eficiente: 1 query para N filas.
     */
    async createDeliveries(
        deliveries: Array<{
            messageId: string;
            deviceId: string;
            fcmToken: string;
            success: boolean;
            fcmResponse: Prisma.InputJsonValue;
            errorCode?: string | null;
        }>,
    ): Promise<void> {
        if (deliveries.length === 0) return;
        await prisma.pushDelivery.createMany({ data: deliveries });
    }

    /** Mensaje por ID con sus entregas (para response del POST). */
    async findByIdWithDeliveries(id: string): Promise<MessageWithDeliveries | null> {
        return prisma.message.findUnique({
            where: { id },
            include: { deliveries: true },
        });
    }

    /**
     * Bandeja de entrada: mensajes RECIBIDOS por el usuario, ordenados por fecha desc.
     * Incluye datos del remitente para que la app pinte foto y nombre directamente.
     */
    async findInbox(
        recipientEmail: string,
        page: number,
        pageSize: number,
    ): Promise<{ messages: MessageWithUsers[]; total: number }> {
        const skip = (page - 1) * pageSize;

        const [messages, total] = await Promise.all([
            prisma.message.findMany({
                where: { recipientEmail },
                orderBy: { createdAt: 'desc' },
                skip,
                take: pageSize,
                include: {
                    sender: {
                        select: { email: true, fullName: true, photoUrl: true, jobTitle: true },
                    },
                    recipient: {
                        select: { email: true, fullName: true, photoUrl: true, jobTitle: true },
                    },
                },
            }),
            prisma.message.count({ where: { recipientEmail } }),
        ]);

        return { messages, total };
    }

    /** Mensajes ENVIADOS por el usuario. */
    async findSent(
        senderEmail: string,
        page: number,
        pageSize: number,
    ): Promise<{ messages: MessageWithUsers[]; total: number }> {
        const skip = (page - 1) * pageSize;

        const [messages, total] = await Promise.all([
            prisma.message.findMany({
                where: { senderEmail },
                orderBy: { createdAt: 'desc' },
                skip,
                take: pageSize,
                include: {
                    sender: {
                        select: { email: true, fullName: true, photoUrl: true, jobTitle: true },
                    },
                    recipient: {
                        select: { email: true, fullName: true, photoUrl: true, jobTitle: true },
                    },
                },
            }),
            prisma.message.count({ where: { senderEmail } }),
        ]);

        return { messages, total };
    }
}

export const messageRepository = new MessageRepository();