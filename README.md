# Sistema de Mensajería Corporativa

Examen final — Desarrollo de Aplicaciones Móviles
Universidad Pontificia Bolivariana — Bucaramanga

## Estructura

- `backend/` — API REST con Node.js, Express, TypeScript, Prisma, PostgreSQL, Firebase Admin SDK.
- `mobile/` — App móvil con Flutter (Android, iOS, Web).
- `docs/` — Documentación del proyecto.

## Requisitos previos

- Node.js 20 LTS
- Flutter 3.24+
- Docker Desktop (para PostgreSQL local)
- Cuenta Firebase configurada según la guía de la materia

## Inicio rápido

```bash
# 1. Levantar PostgreSQL
docker compose up -d

# 2. Back-end
cd backend
npm install
npx prisma migrate dev
npm run dev

# 3. App móvil (en otra terminal)
cd mobile
flutter pub get
flutter run
```

## Arquitectura

Ver `docs/architecture.md`.