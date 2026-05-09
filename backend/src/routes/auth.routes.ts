// src/routes/auth.routes.ts
// Rutas de autenticación.

import { Router } from 'express';
import { authController } from '../controllers/auth.controller';
import { authMiddleware } from '../middleware/auth.middleware';
import { validate } from '../middleware/validate.middleware';
import { uploadPhoto } from '../lib/upload';
import {
    registerSchema,
    loginSchema,
    logoutSchema,
} from '../schemas/auth.schema';
import { asyncHandler } from '../middleware/error.middleware';

const router = Router();

router.post(
    '/register',
    uploadPhoto.single('photo'),
    validate(registerSchema),
    asyncHandler(authController.register.bind(authController)),
);

router.post(
    '/login',
    validate(loginSchema),
    asyncHandler(authController.login.bind(authController)),
);

router.post(
    '/logout',
    authMiddleware,
    validate(logoutSchema),
    asyncHandler(authController.logout.bind(authController)),
);

export { router as authRoutes };