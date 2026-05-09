// src/services/auth.service.ts
// Servicio de autenticación: registro, login, logout.

import { User } from '@prisma/client';
import { userRepository } from '../repositories/user.repository';
import { deviceRepository } from '../repositories/device.repository';
import { hashPassword, verifyPassword } from '../lib/bcrypt';
import { signAuthToken } from '../lib/jwt';
import { HttpErrors } from '../middleware/error.middleware';
import { logger } from '../lib/logger';
import type { RegisterInput, LoginInput, LogoutInput } from '../schemas/auth.schema';

export interface PublicUser {
    email: string;
    fullName: string;
    photoUrl: string | null;
    phoneNumber: string;
    jobTitle: string;
    authProvider: string;
    createdAt: Date;
}

export interface AuthResponse {
    user: PublicUser;
    accessToken: string;
}

export function toPublicUser(user: User): PublicUser {
    return {
        email: user.email,
        fullName: user.fullName,
        photoUrl: user.photoUrl,
        phoneNumber: user.phoneNumber,
        jobTitle: user.jobTitle,
        authProvider: user.authProvider,
        createdAt: user.createdAt,
    };
}

export class AuthService {
    async register(input: RegisterInput, photoUrl: string | null): Promise<AuthResponse> {
        const existing = await userRepository.findByEmail(input.email);
        if (existing) {
            throw HttpErrors.conflict('Ya existe una cuenta con ese email', 'EMAIL_TAKEN');
        }

        const passwordHash = await hashPassword(input.password);

        const user = await userRepository.create({
            email: input.email,
            passwordHash,
            fullName: input.fullName,
            phoneNumber: input.phoneNumber,
            jobTitle: input.jobTitle,
            photoUrl,
            authProvider: 'LOCAL',
        });

        await deviceRepository.upsertForUser(input.fcmToken, user.email);

        const accessToken = signAuthToken({ email: user.email });

        logger.info({ email: user.email }, 'User registered');
        return { user: toPublicUser(user), accessToken };
    }

    async login(input: LoginInput): Promise<AuthResponse> {
        const user = await userRepository.findByEmail(input.email);
        if (!user) {
            throw HttpErrors.unauthorized('Credenciales inválidas', 'INVALID_CREDENTIALS');
        }

        const ok = await verifyPassword(input.password, user.passwordHash);
        if (!ok) {
            throw HttpErrors.unauthorized('Credenciales inválidas', 'INVALID_CREDENTIALS');
        }

        await deviceRepository.upsertForUser(input.fcmToken, user.email);

        const accessToken = signAuthToken({ email: user.email });

        logger.info({ email: user.email }, 'User logged in');
        return { user: toPublicUser(user), accessToken };
    }

    async logout(input: LogoutInput, requesterEmail: string): Promise<void> {
        const device = await deviceRepository.findByFcmToken(input.fcmToken);
        if (device && device.userEmail === requesterEmail) {
            await deviceRepository.deleteByFcmToken(input.fcmToken);
            logger.info({ email: requesterEmail }, 'Device unregistered (logout)');
        }
    }
}

export const authService = new AuthService();