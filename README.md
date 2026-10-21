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

## Status

Both panels are built end to end — see `docs/ROADMAP.md` for the module-by-module
map and the short list of what is still open.

- **Superadmin**: dashboard & analytics, companies + tags, channel providers,
  system/transaction logs with Excel + invoice PDFs, preset authoring in the Frame
  Editor, platform settings (admins & permissions, versions, notifications, credit
  rules and conversion rate, custom fields).
- **Admin**: dashboard, contacts (CSV import/export, tags, custom fields, opt-out),
  Frame Editor, campaign wizard with test send and scheduling, wallet with Razorpay
  and invoices, channel integrations, team/roles, API keys & webhooks.

Useful scripts:

```bash
npm --workspace backend run db:sync      # create/alter tables
npm --workspace backend run db:seed      # superadmin + demo tenant
npm --workspace backend run db:reprice   # re-price frames after credit-rule changes
npm --workspace backend run demo:run     # run the seeded demo campaign end-to-end
```

See `docs/` for the full status report.
