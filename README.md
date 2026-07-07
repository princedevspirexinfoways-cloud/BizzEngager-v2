# BizzEngager

Multi-tenant platform for **bulk WhatsApp / Email / SMS campaigns** with per-contact
personalized creatives.

- **Superadmin panel** — manages client companies (tenants), the shared preset/shape
  library, channel providers, credit pricing, and platform-wide config.
- **Admin (company) panel** — contacts, a Canva-like Frame Editor, multi-channel
  campaigns, and a credit wallet.

## Tech stack

| Layer      | Choice                                                   |
| ---------- | -------------------------------------------------------- |
| Frontend   | React + Vite                                             |
| Backend    | Node.js + Express                                        |
| ORM / DB   | Sequelize + MySQL 8                                      |
| Queue      | BullMQ on Redis (campaign send pipeline)                 |
| Realtime   | Socket.IO (dashboard updates, campaign status, notices)  |
| Auth       | JWT access/refresh, granular permissions, 2FA (OTP/TOTP) |

## Repository layout

```
backend/          Node API, Sequelize models, BullMQ queues, Socket.IO
frontend/         React + Vite app (scaffold)
docker-compose.yml  MySQL + Redis for local development
```

## Getting started

```bash
# 1. Start MySQL + Redis
npm run infra:up

# 2. Install deps
npm install

# 3. Configure backend env
cp backend/.env.example backend/.env   # a dev .env is already provided

# 4. Create tables + seed the platform superadmin and a demo company
npm --workspace backend run db:sync
npm --workspace backend run db:seed

# 5. Run the API (and, in another terminal, the campaign worker)
npm run dev:backend
npm --workspace backend run worker:dev
```

API base: `http://localhost:4000/api/v1` — health check at `/api/v1/health`.

## Foundation status (this slice: backend core)

Implemented:

- Config + infra: env validation, Sequelize pool, Redis/BullMQ, pino logging, Socket.IO
- Full Sequelize schema for **both panels** (tenancy, auth, contacts, frames/presets/
  shapes, channels, campaigns, wallet, logs, platform config)
- Reusable **cursor/offset pagination** primitive used across every listing
- **Auth** for Superadmin / Company Admin / Team member: JWT access+refresh, granular
  per-module permissions, 2FA scaffold (email OTP + TOTP), login logging
- **Provider adapter** interface + real **Meta WhatsApp Cloud API** adapter, mock
  SMS/Email behind the same contract
- **BullMQ** campaign queue + worker with provider rate throttling
- **Socket.IO** emitters for dashboard/status/notifications, per-company & per-user rooms
- Seed script + health checks

See `docs/` for module-by-module roadmap (derived from the product spec).
