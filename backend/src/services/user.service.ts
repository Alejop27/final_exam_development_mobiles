// src/services/user.service.ts
// Servicio de usuarios: listar y obtener detalle.

import { userRepository } from '../repositories/user.repository';
import { HttpErrors } from '../middleware/error.middleware';
import { toPublicUser, PublicUser } from './auth.service';

export class UserService {
    async listAllExcept(requesterEmail: string): Promise<PublicUser[]> {
        const users = await userRepository.findAllExcept(requesterEmail);
        return users.map(toPublicUser);
    }

    async getByEmail(email: string): Promise<PublicUser> {
        const user = await userRepository.findByEmail(email);
        if (!user) {
            throw HttpErrors.notFound('Usuario no encontrado', 'USER_NOT_FOUND');
        }
        return toPublicUser(user);
    }
}

export const userService = new UserService();