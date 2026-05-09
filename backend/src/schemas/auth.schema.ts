// src/schemas/auth.schema.ts
// Validación Zod de los inputs de los endpoints de autenticación.

import { z } from 'zod';

export const registerSchema = z.object({
    email: z
        .string()
        .trim()
        .toLowerCase()
        .email('Email inválido')
        .max(191, 'Email demasiado largo'),
    password: z
        .string()
        .min(6, 'La contraseña debe tener al menos 6 caracteres')
        .max(72, 'La contraseña no puede exceder 72 caracteres'),
    fullName: z
        .string()
        .trim()
        .min(2, 'El nombre debe tener al menos 2 caracteres')
        .max(150, 'El nombre es demasiado largo'),
    phoneNumber: z
        .string()
        .trim()
        .min(7, 'Número telefónico inválido')
        .max(20, 'Número telefónico inválido'),
    jobTitle: z
        .string()
        .trim()
        .min(2, 'El cargo debe tener al menos 2 caracteres')
        .max(100, 'El cargo es demasiado largo'),
    fcmToken: z
        .string()
        .trim()
        .min(10, 'Token FCM inválido')
        .max(500, 'Token FCM inválido'),
});

export type RegisterInput = z.infer<typeof registerSchema>;

export const loginSchema = z.object({
    email: z.string().trim().toLowerCase().email('Email inválido'),
    password: z.string().min(1, 'La contraseña es obligatoria'),
    fcmToken: z
        .string()
        .trim()
        .min(10, 'Token FCM inválido')
        .max(500, 'Token FCM inválido'),
});

export type LoginInput = z.infer<typeof loginSchema>;

export const logoutSchema = z.object({
    fcmToken: z
        .string()
        .trim()
        .min(10, 'Token FCM inválido')
        .max(500, 'Token FCM inválido'),
});

export type LogoutInput = z.infer<typeof logoutSchema>;