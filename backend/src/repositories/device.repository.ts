// src/repositories/device.repository.ts
// Repositorio de dispositivos / tokens FCM.

import { Device } from '@prisma/client';
import { prisma } from '../lib/prisma';

export class DeviceRepository {
    async findByFcmToken(fcmToken: string): Promise<Device | null> {
        return prisma.device.findUnique({ where: { fcmToken } });
    }

    async findAllByUser(userEmail: string): Promise<Device[]> {
        return prisma.device.findMany({ where: { userEmail } });
    }

    async create(data: { fcmToken: string; userEmail: string }): Promise<Device> {
        return prisma.device.create({ data });
    }

    async upsertForUser(fcmToken: string, userEmail: string): Promise<Device> {
        return prisma.device.upsert({
            where: { fcmToken },
            update: { userEmail, lastSeenAt: new Date() },
            create: { fcmToken, userEmail },
        });
    }

    async deleteByFcmToken(fcmToken: string): Promise<void> {
        await prisma.device.deleteMany({ where: { fcmToken } });
    }
}

export const deviceRepository = new DeviceRepository();