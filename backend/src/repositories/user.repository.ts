// src/repositories/user.repository.ts
// Repositorio de usuarios. ÚNICO punto de acceso a la tabla `users`.

import { Prisma, User } from '@prisma/client';
import { prisma } from '../lib/prisma';

export class UserRepository {
    async findByEmail(email: string): Promise<User | null> {
        return prisma.user.findUnique({ where: { email } });
    }

    async create(data: Prisma.UserCreateInput): Promise<User> {
        return prisma.user.create({ data });
    }

    async findAllExcept(email: string): Promise<User[]> {
        return prisma.user.findMany({
            where: { email: { not: email } },
            orderBy: { fullName: 'asc' },
        });
    }

    async update(email: string, data: Prisma.UserUpdateInput): Promise<User> {
        return prisma.user.update({ where: { email }, data });
    }
}

export const userRepository = new UserRepository();