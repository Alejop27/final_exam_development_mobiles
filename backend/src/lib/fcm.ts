// src/lib/fcm.ts
// Wrapper sobre firebase-admin/messaging para enviar notificaciones push.

import admin from 'firebase-admin';
import { logger } from './logger';

export interface FcmSendResult {
    fcmToken: string;
    success: boolean;
    messageId?: string;
    errorCode?: string;
    rawResponse: unknown;
}

export async function sendPushToToken(params: {
    fcmToken: string;
    title: string;
    body: string;
    data?: Record<string, string>;
}): Promise<FcmSendResult> {
    const { fcmToken, title, body, data } = params;

    try {
        const messageId = await admin.messaging().send({
            token: fcmToken,
            notification: { title, body },
            data,
            android: {
                priority: 'high',
                notification: { sound: 'default', channelId: 'messages' },
            },
            apns: {
                payload: { aps: { sound: 'default', badge: 1 } },
            },
        });

        return {
            fcmToken,
            success: true,
            messageId,
            rawResponse: { messageId },
        };
    } catch (err) {
        const errorCode = (err as { code?: string }).code ?? 'unknown';
        logger.warn({ err, fcmToken, errorCode }, 'FCM send failed');
        return {
            fcmToken,
            success: false,
            errorCode,
            rawResponse: { error: errorCode, message: String(err) },
        };
    }
}

export async function sendPushToTokens(params: {
    fcmTokens: string[];
    title: string;
    body: string;
    data?: Record<string, string>;
}): Promise<FcmSendResult[]> {
    const { fcmTokens, ...rest } = params;
    return Promise.all(
        fcmTokens.map((token) => sendPushToToken({ fcmToken: token, ...rest })),
    );
}