// src/routes/user.routes.ts
// Rutas de usuarios. Todas requieren autenticación.

import { Router } from 'express';
import { userController } from '../controllers/user.controller';
import { authMiddleware } from '../middleware/auth.middleware';
import { asyncHandler } from '../middleware/error.middleware';

const router = Router();

router.use(authMiddleware);

router.get('/', asyncHandler(userController.listAll.bind(userController)));
router.get('/me', asyncHandler(userController.getMe.bind(userController)));
router.get('/:email', asyncHandler(userController.getByEmail.bind(userController)));

export { router as userRoutes };