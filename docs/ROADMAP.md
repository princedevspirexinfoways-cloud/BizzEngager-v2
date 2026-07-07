# BizzEngager — build roadmap

Vertical-slice plan derived from the product spec. **Slice 0 (this delivery)** is
the backend core foundation everything else builds on. Each later slice is a
thin vertical: models already exist, so a slice is mostly services + controllers
+ routes + (later) UI.

## ✅ Slice 0 — Backend core foundation (done)

- Monorepo + Docker (MySQL 8 on host port **3307**, Redis 6379)
- Full Sequelize schema for **both panels** (33 models + join tables)
- Config/infra: env validation, pooled Sequelize, Redis, pino, Socket.IO
- Reusable pagination (`utils/pagination.js`): offset + keyset/cursor
- Auth: Superadmin / Company Admin / Team — JWT access+refresh (rotation),
  granular permissions, 2FA scaffold (email OTP + TOTP), login audit
- Providers: adapter contract + real **Meta WhatsApp Cloud API**, mock SMS/Email
- BullMQ campaign pipeline (dispatch fan-out → throttled send → status), credit
  reserve/refund ledger, Socket.IO realtime (cross-process via Redis bridge)
- Meta status webhook (delivered/read receipts)
- Seed (superadmin + runnable demo tenant) + health checks

## Superadmin panel (Part A) — remaining slices

| Spec § | Module | Key models |
| --- | --- | --- |
| A.1 | Dashboard (date-range stats, growth %, charts) | Company, Transaction, LoginLog, ErrorLog, Frame, Campaign |
| A.2 | Analytics & Reporting (ARPU, per-user breakdown) | Company, Transaction, Campaign, CampaignRecipient |
| A.3 | Companies (CRUD, tags, credit add, archive, impersonate) | Company, CompanyTag, CompanyUser |
| A.4 | Channel Configuration (WhatsApp/SMS/Email providers) | ChannelProvider |
| A.5 | System Logs (login/campaign/error, Excel export) | LoginLog, CampaignLog, ErrorLog |
| A.6 | Transaction Logs (invoices, PDF/Excel) | Transaction |
| A.7 | **Preset & Shape management** (Draft→Published→Archived) | Preset, PresetCategory, Shape |
| A.8 | Settings (profile/2FA, admins+permissions, versions, notifications, credit config, custom fields) | Superadmin, Version, PlatformNotification, CreditConfig, ElementRule, CustomField |

## Admin (company) panel (Part B) — remaining slices

| Spec § | Module | Key models |
| --- | --- | --- |
| B.1 | Dashboard (delivered/read ratios, channel status, graphs) | Contact, Campaign, Frame, CompanyChannelIntegration |
| B.2 | Contacts (CRUD, bulk CSV, tags, custom fields, consent/opt-out) | Contact, ContactTag, CustomField, ContactFieldValue |
| B.3 | Frames + **Frame Editor** (Arrange/Elements/Photos/Presets/Text) | Frame, FrameCategory, Preset, Shape, Photo, Font |
| B.4 | Campaigns (wizard: frame→audience→channel→template→test→review) | Campaign, CampaignRecipient, Template |
| B.5 | Wallet (Billing invoices, Transactions, auto-recharge) | Transaction, CreditPackage |
| B.6 | Channel Integration (provider accounts, templates) | CompanyChannelIntegration, Template |
| B.7 | Settings (account, team+roles, security, API integrations) | CompanyUser, CompanyRole |

## Notable deferred decisions (flagged in the spec)

- **Frame Editor**: data model (`Frame.canvasJson`, presets, shapes) is in place;
  the canvas UI + server-side per-contact render pipeline is its own large slice.
- **Credit element rules** (A.8.5): schema (`ElementRule`) exists; the spec still
  asks whether cost is flat / by-category / by-count — resolve before building UI.
- **Providers**: only Meta is a real adapter; Wati/Interakt/AiSensy/SMS/Email run
  through the mock adapter behind the same contract until real keys are wired.

## Conventions to keep across slices

- Every listing uses `parseListQuery` + `paginate`/`paginateByCursor`.
- Company-scoped controllers read `req.companyId` (set by `requireCompany`) and
  must filter every query by it — never trust a body/param companyId.
- Guard writes with `authorize(module, action)`; superadmin root & company owners
  bypass automatically.
- Emit realtime updates through `sockets/emitters.js` so API and worker behave
  identically.
- Wrap async handlers in `asyncHandler`; throw `AppError` for expected failures.
