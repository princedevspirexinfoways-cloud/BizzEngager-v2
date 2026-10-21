# BizzEngager — build status

Both panels are feature-complete against the product spec except for the items in
**Still open** at the bottom. This file tracks what exists so nobody has to
re-derive it from the code; per-module detail lives next to the code itself.

## Shipped

### Platform / foundation
- Monorepo + Docker (MySQL 8 on host port **3307**, Redis 6379), Sequelize schema
  for both panels, pooled config, pino logging, Socket.IO (cross-process via Redis).
- Auth for Superadmin / Company Admin / Team: JWT access+refresh with rotation,
  granular per-module permissions, 2FA (email OTP + TOTP), login audit.
- BullMQ campaign pipeline: dispatch fan-out → per-contact render → throttled send
  → status webhooks, with credit reserve/refund ledger.
- Providers: real **Meta WhatsApp Cloud API** and **BizzRiser** adapters (incl.
  template sync); Wati / Interakt / AiSensy / DoubleTick / Zapup, SMS and Email
  still run through the mock adapter behind the same contract.
- `ProviderError` surfaces as HTTP 502 with the provider's own message, so send
  failures are diagnosable from the UI.

### Superadmin panel (Part A)
| § | Module | Notes |
| --- | --- | --- |
| A.1 | Dashboard | date-range stats, growth %, revenue chart, companies-added chart, error panel |
| A.2 | Analytics | ARPU, active/most-active/low-credit companies, average credit usage, per-company panel + CSV export |
| A.3 | Companies | CRUD, tag picker + Manage Tags popup, credit top-up, activate/deactivate, impersonation, tag/date filters |
| A.4 | Channel Configuration | provider CRUD per channel (base URLs fixed here, not by companies) |
| A.5 | System Logs | login/campaign/error tabs, date filters, Excel export |
| A.6 | Transaction Logs | filters, Excel export, detail view, invoice PDF |
| A.7 | Presets & Shapes | presets authored **in the Frame Editor** (`/superadmin/preset-editor`) with Draft→Published→Archived; shapes via direct SVG upload |
| A.8 | Settings | profile + 2FA, superadmins with a granular permission matrix, versions and notifications with rollout/recipient targeting, credit rules, INR→credit rate, custom fields |

### Admin (company) panel (Part B)
| § | Module | Notes |
| --- | --- | --- |
| B.1 | Dashboard | totals, delivered/read ratios, channel status, campaign + credit-usage graphs |
| B.2 | Contacts | CRUD, business logo, consent, custom fields, tags (creatable inline), CSV import with sample download, bulk archive/delete (by selection or tag), public opt-out links |
| B.3 | Frames + Frame Editor | categories, filters (status/category/size/date), duplicate/archive/restore, editor per below |
| B.4 | Campaigns | wizard (frame → audience → provider → template mapping → review), live audience count, personalized previews, **test send**, timezone + future-only scheduling, throughput ETA |
| B.5 | Wallet | Razorpay purchases, billing + transactions tabs, invoice PDF, all-invoices ZIP, Excel history, low-balance alerts, auto-recharge config |
| B.6 | Channel Integration | provider accounts, template sync, approved-template gating in the wizard |
| B.7 | Settings | account + timezone, notification history and bell, team & roles with permissions, security/2FA, API keys + webhooks |

### Credit model (spec A.8.5)
`ElementRule` drives real pricing: frames are classified into
text/shape/icon/photo/preset elements and priced with `flat`, `per_count` or
`by_category` rules. The editor shows a live estimate (`lib/creditRules.js`), the
API re-prices authoritatively on every save (`wallet/elementCost.service.js`), and
the send pipeline charges that stored figure plus 1 credit per message. Existing
frames can be re-priced after a rule change with
`npm --workspace backend run db:reprice`.

## Frame Editor

Feature-complete against spec section B.3: align (frame / selection / key object)
and distribute, smart guides + grid snap, **rulers with draggable, lockable custom
guides**, **margin & safe-zone snapping**, stacking, layers with thumbnails,
rename, lock/hide, reorder, search and **multi-select batch ops**, elements with
recolor/recently-used/custom SVG upload, **shape combining (weld / trim /
intersect / simplify via paper.js)**, photos with crop, replace, adjustments,
filters and **HEIC auto-conversion on upload**, presets, text with **font browsing
by category, brand-font upload and supported-weight filtering**, find & replace,
format painter, vertical text, super/subscript, right-click menu, and
**multi-page documents with linked-or-independent headers/footers and dynamic
tokens** ({{page}}, {{pages}}, {{date}}, {{title}}).

Document format: `Frame.canvasJson` is v2 (`{ version, pages, chrome, guides,
margins }`); v1 single-canvas documents still load unchanged. Helpers live in
`backend/src/utils/frameDocument.js` and
`frontend/src/pages/admin/frame-editor/document.js` — keep them in step. Campaign
creatives render page 1 with shared chrome merged in and tokens resolved.

## Still open

- **Auto-recharge charging** — thresholds, alerts and config are live, but an
  unattended top-up needs Razorpay tokenization (customer + saved token/mandate).
  Until then a top-up is confirmed manually from Add Credits.
- **Real provider adapters** for the remaining WhatsApp vendors, SMS and Email.
- **Backend lint** — `npm --workspace backend run lint` fails on an eslintrc →
  flat-config migration, unrelated to application code.

## Conventions to keep

- Every listing uses `parseListQuery` + `paginate`/`paginateByCursor`.
- Company-scoped controllers read `req.companyId` (set by `requireCompany`) and
  filter every query by it — never trust a body/param companyId.
- Guard writes with `authorize(module, action)`; superadmin root & company owners
  bypass automatically.
- Emit realtime updates through `sockets/emitters.js` so API and worker behave
  identically.
- Wrap async handlers in `asyncHandler`; throw `AppError` for expected failures.
- Money/credit figures are computed server-side; the client never supplies them.
