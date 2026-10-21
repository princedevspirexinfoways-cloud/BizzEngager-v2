# Spec Coverage — `BizzEngager - Final Draft.pdf` vs. this codebase

Every line-item in the 15-page spec, per module, checked against the current
code. Audited 2026-08-05 against `master`.

**Legend** — ✅ implemented · ⚠️ partial (detail differs or half-built) · ❌ missing · ➕ built but not in the spec

---

# Part A — Superadmin Panel

## A.1 Dashboard
Code: `frontend/src/pages/superadmin/Dashboard.jsx`, `backend/src/modules/superadmin/dashboard/dashboard.routes.js`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Dynamic welcome message with the Superadmin's name | ✅ | Time-aware greeting from `profile.name` (`lib/greeting.js`); falls back to "Dashboard" while the profile loads. |
| 2 | Global date range filter — Last Week / Last Month / Last Year / Custom | ✅ | All four. Custom reveals a start/end pair seeded with the current window; fixed an inclusive-end-date off-by-one in `resolveDateWindow` while wiring it up. |
| 3 | Total Companies + growth % vs equivalent prior period | ✅ | `growthPct(newCompanies, prevCompanies)`. |
| 4 | Total Revenue + same period-over-period growth | ✅ | |
| 5 | Error logs panel | ❌ | **Removed on request** this session and replaced with the Revenue chart. Deliberate deviation. Data still exists (`ErrorLog`) and is visible under System Logs. |
| 6 | Revenue chart | ✅ | Area chart, now in the 2-up row. |
| 7 | Users/Companies activity chart | ✅ | "Companies Added" bar chart. |
| 8 | Total presets added by the Superadmin | ✅ | |

## A.2 Analytics & Reporting
Code: `frontend/src/pages/superadmin/Analytics.jsx`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Revenue — ARPU | ✅ | revenue ÷ active companies |
| 2 | Companies — active, most active, running low on credits | ✅ | All three; Low on Credits is now paginated (8/page, cap 100). |
| 3 | Total Frames, broken down by user | ✅ | Tile + per-company table column |
| 4 | Total Broadcasts, broken down by user | ✅ | |
| 5 | Total Messages Sent — per user | ✅ | |
| 6 | Average Credit Usage — per user | ✅ | |
| 7 | Detailed per-user panel, every statistic for one user | ✅ | `PerCompanyBreakdown`, paginated + CSV export |
| 8 | Credit usage breakdown per user/company | ✅ | `creditsUsed` / `creditsLeft` columns |

## A.3 Companies
Code: `frontend/src/pages/superadmin/Companies.jsx`, `backend/src/modules/superadmin/companies/`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Search bar | ✅ | |
| 2 | Filters — tag, start date, end date | ✅ | Plus a status filter (➕) |
| 3 | "Add Company" action | ✅ | |
| 4 | Manage Tags popup — Tag Name, Total Companies, Date & Time; Edit/Delete | ✅ | `companyCount` subquery |
| 5 | Add Company fields — Tag(s) **required**, Owner Name, Company Name req, Mobile req, Email req, Address, Credits opt, GST, Password | ✅ | Tags enforced client-side. Owner Name is optional (matches spec — it is *not* marked required there). |
| 6 | Listing columns — Company Name, Tags, Credits (inline "+ Add"), Used Credits, Status, Email, Owner Name, Created | ✅ | Owner is its own sortable column; the Credits cell carries an inline "+ Add" chip. Email stays a sub-line under Company Name. |
| 7 | Row actions — Add Credit, Edit, Activate/Deactivate, Archive/Delete (restorable), View, Login-as | ✅ | All present. Archive is the spec's "Delete" — a confirmed soft-delete that locks the company's users out and stays restorable; archived rows show the archive date and swap their actions for View + Restore. |

## A.4 Channel Configuration
Code: `frontend/src/pages/superadmin/Manage.jsx` → `ChannelConfig`, `backend/.../channels/provider.routes.js`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Three tabs — WhatsApp, SMS, Email | ✅ | One tab per channel; each remounts its own list. |
| 2 | Listing — Provider/Channel Name, Base URL / API Endpoint, Added/Updated Date & Time | ✅ | Provider (+ key), Base URL / endpoint, Rate/s, Active, and an Added / Updated column. |
| 3 | Row actions — View, Edit, Delete | ✅ | View opens a read-only detail modal; Edit + Delete via CrudPage. |

## A.5 System Logs
Code: `frontend/src/pages/superadmin/Logs.jsx`, `backend/.../superadmin/logs/logs.routes.js`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Filters — Company Name, Start Date, End Date | ✅ | |
| 2 | Download Logs (Excel export) | ✅ | Per-tab `.xlsx`, respects the date range |
| 3 | Login Logs tab — Company, Status, Email, Date & Time | ✅ | "Event" badge + IP (➕) |
| 4 | Campaign Logs tab — Company, Email, Channel, Contacts, Date & Time | ✅ | Email column added to the table and the Excel export. The column existed on the model but was never written — the campaign runtime now fills it, and historical rows were backfilled. |
| 5 | Error Logs tab — Company, Message, Date & Time | ✅ | Plus Source (➕) |

## A.6 Transaction Logs
Code: `frontend/src/pages/superadmin/Transactions.jsx`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Search bar | ✅ | |
| 2 | Filters — Company, Status, Start/End date | ✅ | |
| 3 | Download (Excel export) | ✅ | |
| 4 | Columns — Invoice ID, Company, Status, Amount, Credit, Type, Date & Time | ✅ | All seven |
| 5 | Row actions — View (full detail), Download (PDF) | ✅ | Detail modal + PDF invoice |

## A.7 Preset & Shape Management
*Flagged in the spec as the single most important module.*
Code: `backend/src/modules/superadmin/library/library.routes.js`, `frontend/src/pages/superadmin/Manage.jsx` → `Library`

### 7.1 Presets
| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Superadmin can create, edit, publish presets | ✅ | Built in the shared editor at `/superadmin/preset-editor` |
| 2 | A preset is a connected group of shapes forming one cohesive graphic | ✅ | Stored as grouped canvas JSON |
| 3 | Frames are never presets; a preset sits on top of a frame | ✅ | Separate `Frame` and `Preset` models |
| 4 | Text must be insertable inside every shape in a preset | ✅ | `shapeText` prop on shapes |
| 5 | Draft → Published → Archived workflow before visibility in company editors | ✅ | `/presets/:id/publish|archive|draft`; companies read only `published` |
| 6 | Preset categories manageable without a code release | ✅ | `PresetCategory` CRUD, creatable inline from the editor |
| 7 | Same editor as the Admin panel | ✅ | `FrameEditorPage mode="preset"` |
| — | **Audience scoping — all companies or selected tags** | ➕ | Added this session; not in the spec. `audience` + `audienceTagIds` on `Preset`, filtered in `/admin/design/brand-presets`. |

### 7.2 Shapes
| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Superadmin can add shapes to the shared library | ✅ | |
| 2 | Direct SVG upload with the same per-region recolor pipeline as the editor | ✅ | `UploadSvgButton` + `recolorRegions` |
| 3 | One ingestion path for library and admin-uploaded custom shapes | ✅ | Shared `Shape` model, scoped brand/company |
| 4 | Same editor for Superadmin | ✅ | |

## A.8 Settings
Code: `frontend/src/pages/superadmin/SettingsTabs.jsx`, `Manage.jsx`

### 8.1 Profile & Security
| Spec detail | Status | Notes |
|---|---|---|
| Editable Superadmin account details | ✅ | |
| Sign-out | ✅ | |
| 2FA — email verification **and** authenticator app (TOTP) | ✅ | `/auth/2fa/totp/*` + `/auth/2fa/email/*` |

### 8.2 Superadmin Management & Permissions
| Spec detail | Status | Notes |
|---|---|---|
| Listing — Name, Email, Created, Last Login | ✅ | |
| Row actions — Edit, View, Delete | ✅ | View opens a read-only account + permission detail; Edit + Delete alongside. |
| Search bar + "Add New" | ✅ | |
| Add popup — Name, Email, Password, Confirm Password | ✅ | |
| Granular permissions per module | ✅ | All 13 spec modules present with their action sets (Companies, Billing, System Logs, Presets, Shapes, Analytics, Version, Notifications, Credit Config, Custom Fields, Channel Config…) |
| "Special" action beyond Add/Update/Delete | ✅ | Declared for all seven modules the spec lists. Enforced where a beyond-CRUD action exists: impersonation, log export, preset publish/archive/draft, and the INR→credit rate. |

### 8.3 Version Update & Changelog
| Spec detail | Status |
|---|---|
| Listing — Version ID, Name, Description | ✅ |
| View action with full changelog | ✅ |
| "Launch New Version" popup — Name, Description, Changelog | ✅ |
| Rollout target — All Companies or selected companies/tags | ✅ (`rolloutTarget` JSON, resolved server-side) |

### 8.4 Notifications
| Spec detail | Status |
|---|---|
| Listing — Notification ID, Title, Description | ✅ |
| View action | ✅ |
| "Send New Notification" — Title, Description | ✅ |
| Recipient target — All Companies or selected companies/tags | ✅ (+ realtime socket push, ➕) |

### 8.5 Credit Configuration
| Spec detail | Status | Notes |
|---|---|---|
| Element-Based Rules — cost by which elements exist in a frame | ✅ | `ElementRule` CRUD + live estimate in the editor |
| *(Open question in the spec: flat / by category / scale with count)* | ✅ | Resolved as per-element-type rules priced by count |
| Credit Cost Configuration — INR-to-credit rate | ✅ | `CreditRateTab`, `GET/PUT /superadmin/credits/config` |

### 8.6 Custom Field Management
| Spec detail | Status | Notes |
|---|---|---|
| Listing — Field Name, Field Type, Scope | ✅ | Scope column + picker: "All companies" or selected company tags (`appliesTo` / `appliesToTagIds`), enforced at render-time field resolution. "Category-wise" is implemented as company tags — the platform's segmentation primitive everywhere else. "Admin" scope = company-defined fields, managed in the company panel. |
| Row actions — Edit, Delete | ✅ | |
| "Add New Custom Field" popup | ✅ | |

---

# Part B — Admin (Company) Panel

## B.1 Dashboard
Code: `frontend/src/pages/admin/Dashboard.jsx`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Dynamic welcome message with the company name | ✅ | Same greeting helper, from `profile.companyName` |
| 2 | Date range filter (Week/Month/Year/Custom) | ✅ | Same component as A.1, Custom included |
| 3 | Total Contacts, Campaigns, Frames, Scheduled Campaigns | ✅ | |
| 4 | Delivered Ratio and Read Ratio | ✅ | |
| 5 | Channel integration status — WhatsApp / Email / SMS | ✅ | "Channel Integrations" card |
| 6 | Total campaign graph | ✅ | |
| 7 | Credit usage graph | ✅ | |

## B.2 Contacts
Code: `frontend/src/pages/admin/Contacts.jsx`

| # | Spec detail | Status |
|---|---|---|
| 1 | Search bar | ✅ |
| 2 | Add Contact — Tags, Business Name, Owner Name, Contact Number, Email, Business Logo, per-channel consent | ✅ |
| 3 | Bulk Contact Upload — tag selection + CSV | ✅ (with sample CSV, header alias auto-mapping, and a logo ZIP whose filenames are matched against the CSV `image` column) |
| 4 | Bulk archive/delete | ✅ |
| 5 | Manage Tags — add, update, delete | ✅ |
| 6 | Manage Custom Fields — Name, auto Alias, Type, Required toggle | ✅ |
| 7 | Filters — Tags, Date range | ✅ |
| 8 | Listing — Tag, Business Name, Owner Name, Mobile, Consent, Date | ✅ |
| 9 | Row actions — View, Edit, Archive/Delete with recovery window | ✅ (`/archive` + `/restore`) |
| 10 | View Contact showing every configured field | ✅ |
| 11 | Opt-out link marks the contact opted-out per channel and excludes it from future campaigns | ✅ (`modules/public/optout.routes.js`, honoured in audience counts) |

## B.3 Frames
Code: `frontend/src/pages/admin/Misc.jsx` → `Frames`

| # | Spec detail | Status |
|---|---|---|
| 1 | "Add Frame" button | ✅ |
| 2 | Manage Categories (add/update/delete + Date & Time) | ✅ |
| 3 | Search bar | ✅ |
| 4 | Filters — Category, Date range, Aspect ratio/size | ✅ |
| 5 | Listing — Image, Frame Name, Category, Size, Date & Time | ✅ |
| 6 | Row actions — Edit, Duplicate, View, Archive/Delete with recovery | ✅ |
| 7 | Add Frame popup — Name, Category, Size | ✅ |

## B.3a Frame Editor
Code: `frontend/src/pages/admin/frame-editor/`

Tab order matches the spec exactly: **Arrange, Elements, Photos, Presets, Text**.
Live credit estimate is shown persistently in the toolbar ✅.

### 1. Arrange
| Spec detail | Status | Notes |
|---|---|---|
| 1.1 Align to Frame — L/C/R/T/M/B | ✅ | |
| 1.1 Align to Selection (2+ objects) | ✅ | |
| 1.1 Align to Key Object | ✅ | |
| 1.1 Align to a Specific Point (X/Y) | ✅ | |
| 1.1 Switch reference point at any time | ✅ | Selection / Frame / Key Object / Custom |
| 1.2 Distribute H/V, Distribute Centers H/V | ✅ | |
| 1.2 Toggle within selection vs across frame | ✅ | |
| 1.3 Smart spacing guides with live gap distance | ✅ | |
| 1.3 Snap to grid (toggle + size) | ✅ | |
| 1.3 Snap to margins / safe zones | ✅ | |
| 1.3 Custom guide lines dragged off the ruler, lockable | ✅ | `Rulers.jsx` |
| 1.4 Bring to Front / Forward / Backward / Send to Back | ✅ | |
| 1.5 Numeric X, Y, W, H, Rotation | ✅ | |
| 1.5 Lock aspect ratio toggle | ✅ | |
| 1.5 Flip Horizontal / Vertical | ✅ | |
| 1.6 Layer list, front-to-back, drag to reorder | ✅ | |
| 1.6 Rename / Show-Hide / Lock-Unlock per layer | ✅ | |
| 1.6 Group / ungroup with expand-collapse | ✅ | |
| 1.6 Multi-select for batch lock/hide/delete/move | ✅ | |
| 1.6 Thumbnail preview per layer | ✅ | |
| 1.6 Two-way selection sync | ✅ | |
| 1.6 Search/filter layers by name | ✅ | |

### 2. Elements
| Spec detail | Status | Notes |
|---|---|---|
| 2.1 Shapes — rect, circle, line, arrow, polygon, custom path… | ✅ | 10 primitives incl. star, heart, triangle, ellipse |
| 2.1 Icons — line / filled / duotone style | ⚠️ | Icon library + `style` field exist; the three-style split is thin in the seeded set. |
| 2.1 Lines & Connectors | ✅ | Connectors anchor to two objects by id and re-route on move/scale/rotate; they self-remove when an anchor is deleted. |
| 2.2 Keyword search | ✅ | |
| 2.2 "Recently Used" row | ✅ | |
| 2.3 Click to insert, drag-and-drop, shortcuts | ✅ | |
| 2.4 Recolor vector — one swatch per region | ✅ | |
| 2.4 Recolor raster — duotone, shadow + highlight | ✅ | Luminance mapped across a shadow→highlight ramp via stock fabric filters, so the server renderer re-applies it from the serialized JSON. Five presets plus both swatches editable. |
| 2.4 Outline/stroke — on/off, width, colour, dash | ✅ | |
| 2.4 Corner rounding — handle or exact value | ✅ | |
| 2.4 Shadow/glow toggle | ✅ | |
| 2.4 Flip/rotate — drag or exact degrees | ✅ | |
| 2.4 Crop for frame-type/photo elements | ✅ | |
| 2.4 Opacity slider | ✅ | |
| 2.5 Shape combining — Combine, Weld, Trim, Intersect, Simplify | ⚠️ | Weld / Trim / Intersect / Simplify ✅ via paper.js. "Combine" is only distinct from Weld if it means non-destructive compound paths — currently Weld covers it. |
| 2.6 Upload your own SVG, recolorable by region | ✅ | |
| 2.6 Draw a custom shape with a pen/path tool | ✅ | |

### 3. Photos
| Spec detail | Status | Notes |
|---|---|---|
| 3.1 Upload via drag-and-drop or file browser | ✅ | |
| 3.1 JPG, PNG, WEBP, HEIC (auto-converted) | ✅ | `normalizeUpload` does HEIC → JPEG |
| 3.1 Search uploads by filename, delete | ✅ | |
| 3.2 Unsplash — full search, featured/trending default, orientation filter, insert to canvas | ✅ | `unsplash.routes.js` |
| 3.2 Unsplash is the only external source | ✅ | |
| 3.3 Crop — free-form or locked to a shape | ✅ | |
| 3.3 Replace image keeping position/size/crop/effects | ✅ | |
| 3.3 Adjustments — brightness, contrast, saturation, temperature, sharpness | ✅ | All five |
| 3.3 Preset filters with manual sliders underneath | ✅ | 7 presets |
| 3.3 Flip / rotate | ✅ | |
| 3.3 Border/outline around the photo | ✅ | |

### 4. Presets (in-editor)
| Spec detail | Status |
|---|---|
| Two libraries — Brand Presets and My Presets | ✅ |
| 4.1 Categories, manageable on the back end | ✅ |
| 4.2 Search by name/tag, thumbnail, filter by category | ✅ |
| 4.3 Drag-and-drop or click to insert | ✅ |
| 4.3 Always inserted as one grouped object | ✅ |
| 4.4 Ungroup to edit, piece-by-piece | ✅ |
| 4.4 Quick-edit — double-click, smart jumps ("Edit Title/Logo/Name") | ✅ | "Edit <part>" buttons jump straight into a preset's text or image piece without ungrouping. |
| 4.5 Save any grouping as your own preset, stored in My Presets | ✅ |

### 5. Text
| Spec detail | Status | Notes |
|---|---|---|
| 5.1 Heading / Subheading / Body / blank Text Box | ✅ | |
| 5.1 Font-pairing presets | ✅ | |
| 5.2 Categories — Sans Serif, Serif, Display, Handwriting, Monospace | ✅ | |
| 5.2 Brand Fonts pinned at the top | ✅ | Custom font upload |
| 5.2 Weight selector showing only real weights | ✅ | `FONT_WEIGHTS` map |
| 5.2 Font size — input, stepper, quick-pick | ✅ | |
| 5.3 Bold / Italic / Underline / Strikethrough | ✅ | |
| 5.3 Alignment incl. Justify | ✅ | |
| 5.3 Bulleted / numbered lists | ✅ | |
| 5.3 Letter spacing, line height, indent/tab stops | ✅ | Indent/outdent over the selected lines (or the whole box), written as leading spaces so export and per-contact rendering match the canvas exactly. |
| 5.3 Text colour — solid or gradient | ✅ | |
| 5.3 Superscript / subscript | ✅ | |
| 5.3 Format Painter | ✅ | |
| 5.3 Find & Replace across the document | ✅ | |
| 5.3 Vertical text orientation | ✅ | |
| 5.4 Header/Footer layout | ✅ | |
| 5.4 "Apply to all pages" — linked vs independent | ✅ | `chromeMode` |
| 5.4 Dynamic tokens — page number, total pages, date, title | ✅ | `{{page}} {{pages}} {{title}}` |
| Shared: universal colour & fill — solid, brand swatches, wheel, hex, eyedropper | ✅ | |
| Shared: gradients — linear/radial/conic, multi-stop, per-stop opacity | ✅ | |

## B.4 Campaigns
Code: `frontend/src/pages/admin/CampaignWizard.jsx`, `Campaigns.jsx`, `backend/src/modules/admin/campaigns/`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Listing — Frame, Campaign Name, Tag, Type, Date & Time, Status | ✅ | |
| 2 | Row actions — Delete, View Campaign Logs | ✅ | Plus resend-failed / cancel (➕) |
| 3 | Wizard: Title | ✅ | Step "Details" |
| 4 | Select Frame with live preview | ✅ | |
| 5 | Select Audience — tags + live contact count excluding opt-outs | ✅ | `/campaigns/audience-count` |
| 6 | Channel selection | ✅ | |
| 7 | Provider selection | ✅ | |
| 8 | Template selection — fetch & add templates inside the modal | ✅ | |
| 9 | Only Meta-approved WhatsApp templates selectable | ✅ | |
| 10 | Template variable mapping — custom value or custom field | ✅ | |
| 11 | Test Send to one contact / test number | ✅ | `POST /:id/test-send` |
| 12 | Review — full summary + credit deduction matching the editor estimate | ✅ | |
| 13 | Scheduling — date, time, timezone | ✅ | |
| 14 | Automatic rate throttling within provider limits | ✅ | `ratePerSecond` honoured by the BullMQ worker |
| 15 | Estimated completion time shown | ✅ | |
| 16 | Cannot schedule before the current time | ✅ | Validated |

*Wizard is 5 steps (Details, Frame, Audience, Provider, Review) — the spec's items are all present, folded into those steps.*

## B.5 Wallet
Code: `frontend/src/pages/admin/Wallet.jsx`, `backend/src/modules/admin/wallet/`

### 5.1 Billing
| Spec detail | Status |
|---|---|
| "Add Credits" — preset packages or manual entry | ✅ |
| Search bar | ✅ |
| Download All Invoices as a ZIP of PDFs, respecting the date range | ✅ (`/billing/invoices.zip`) |
| Columns — Invoice ID, Particulars, Type, Status, Credits, Date & Time | ✅ |
| Row action — Download Invoice (formatted PDF) | ✅ |
| Date range filter | ✅ |
| Low-balance alert threshold + auto-recharge (saved method, trigger, top-up amount) | ✅ (`PUT /wallet/settings`) |

### 5.2 Transactions
| Spec detail | Status |
|---|---|
| Only deducted-credit and refunded-credit entries | ✅ |
| Search bar, date filter | ✅ |
| Download History as Excel/CSV | ✅ |
| Columns — Transaction ID, Campaign, Type, Status, Amount (green credit / red debit), Date | ✅ |

### 5.3 Logs (Activity & Logs)
| Spec detail | Status |
|---|---|
| System Activity — login/logout, IP, date & time | ✅ |
| Campaign Logs — name, total contacts, Sent/Delivered/Read, status, date | ✅ |
| Error Logs — detailed message, date & time | ✅ |

## B.6 Channel Integration
Code: `frontend/src/pages/admin/Channels.jsx`, `backend/src/modules/admin/channels/`

| # | Spec detail | Status | Notes |
|---|---|---|---|
| 1 | Three tabs — WhatsApp, SMS, Email | ✅ | |
| 2 | "Add Provider" button | ✅ | |
| 3 | WhatsApp columns — Service Provider, Account Name, Phone Number ID, Date & Time | ✅ | |
| 4 | Provider choice: BizzRiser, Wati, Interakt, AiSensy, DoubleTick, Zapup | ✅ | All six have adapters and catalogue rows. BizzRiser and Meta are bespoke; Wati, Interakt, AiSensy, DoubleTick and Zapup share `GenericBspAdapter` driven by per-provider profiles. Endpoint paths and base URLs are superadmin-overridable — see the note under Gap summary. |
| 5 | Base URL & endpoints not editable by the company | ✅ | Configured superadmin-side only |
| 6 | "Add New Template" with provider selection | ✅ | |
| 7 | Template columns — Name, Image Type, Category, Provider, Date & Time | ✅ | |
| 8 | Row action — Delete | ✅ | |

## B.7 Settings
Code: `frontend/src/pages/admin/Settings.jsx`, `settings/IntegrationsTabs.jsx`

### 7.1 Account
| Spec detail | Status |
|---|---|
| Fields captured at company creation, Company ID locked | ✅ |
| Timezone | ✅ |
| Sign-out | ✅ |
| Notification history | ✅ |

### 7.2 Team & Access Management
| Spec detail | Status | Notes |
|---|---|---|
| Listing — Name, Email, Role, Date Added, Last Login | ✅ | |
| Row actions — Edit, Deactivate, Delete | ✅ | Deactivate/Reactivate toggle; the API already refused to deactivate the owner. |
| Search bar + "Add Team Member" | ✅ | |
| Add popup — Name, Email, Role with permission scope over Contacts/Frames/Campaigns/Wallet/Channel Integration | ✅ | 8 modules covered |
| Role management button | ✅ | Roles tab |
| Roles listing — name, user count, added date, Edit/Delete | ✅ | |

### 7.3 Security
| Spec detail | Status |
|---|---|
| Change password requiring current password + email OTP | ✅ |
| 2FA — email verification and TOTP | ✅ |

### 7.4 Integrations
| Spec detail | Status | Notes |
|---|---|---|
| API key | ✅ | Create/list/revoke |
| Full documentation for every endpoint with usage examples | ✅ | Settings → **API Docs**. All 107 admin endpoints, grouped and searchable, each with a copy-ready curl example. |
| Documentation listed on the platform's Integrations page | ✅ | Same Settings area as API Keys and Webhooks. |
| — | ➕ | Webhooks (endpoints, event subscriptions) are built but not in the spec |

---

# Navigation comparison

The spec calls for **eight items per panel, mirrored**. Current build:

| Spec — Superadmin | Built | Spec — Admin | Built |
|---|---|---|---|
| Dashboard | ✅ | Dashboard | ✅ |
| Analytics & Reporting | ✅ (labelled "Analytics") | Contacts | ✅ |
| Companies | ✅ | Frame | ✅ ("Frames") |
| Channel Configuration | ✅ ("Channel Config") | Campaign | ✅ ("Campaigns") |
| System Logs | ✅ | Wallet | ✅ |
| Transaction Logs | ✅ ("Transactions") | Channel Integration | ✅ |
| Presets & Shapes | ✅ | Activity & Logs | ✅ |
| Settings | ✅ | Settings | ✅ |
| — | ➕ **Credits** (9th item) | — | ➕ **Media**, ➕ **Templates** (10 items) |

Both panels have grown past the spec's eight-item structure. Credits, Media and
Templates are all reachable from within their parent modules conceptually
(Settings → Credit Config, Frames → media, Channel Integration → templates), so
they could be folded back if the eight-item symmetry matters.

---

# Beyond the spec (➕)

Built and working, with no spec line-item behind it:

- **Preset audience scoping** — all companies vs. selected company tags (added this session)
- **Company invitations** — email invite flow with a public accept page (`/invite/:token`)
- **Webhooks** — endpoint registration + event subscriptions
- **Realtime notifications** — socket push to targeted companies
- **Impersonation** — superadmin "Login as company"
- **Campaign resend-failed / cancel / provider status sync**
- **Multi-page documents** in the editor with a page strip and per-page export
- **Bulk upload logs** for CSV contact imports
- **Credits nav module** — packages, element rules and conversion rate as a first-class page

---

# Gap summary — what is actually missing

**Not built at all (❌)**
1. Superadmin dashboard error-logs panel (A.1) — removed on request and replaced by the revenue chart. The only remaining ❌, and a deliberate product decision rather than an omission. Re-adding it is a one-line revert whenever you want it back.

**Everything else in the spec is ✅**, with two judgement calls worth recording
rather than "fixing":

- *Icons — line / filled / duotone style* (2.1): the library and its `style`
  field support all three, but the seeded icon set is thin. That is a content
  gap, not a code gap.
- *Shape combining — "Combine"* (2.5): Weld/Trim/Intersect/Simplify are all
  implemented. "Combine" is only a distinct operation if it means non-destructive
  compound paths; as a destructive merge it is exactly Weld, which exists.

## Provider adapter caveat (B.6)

Wati, Interakt, AiSensy, DoubleTick and Zapup run through `GenericBspAdapter`,
driven by a profile per provider in `backend/src/providers/whatsapp/profiles.js`.
Each profile encodes that provider's published request shape — auth style,
endpoint path, body layout, success detection — and all of it was exercised
against a stub server (correct paths, headers, phone normalisation, variable
mapping, retry classification, credential masking).

What has **not** happened is a live send against a real account for any of the
five. Confirm the endpoint paths and credential names against each provider's own
documentation before going live. Two mitigations are built in:

- `baseUrl` and every endpoint path are overridable per provider from **Channel
  Configuration**, so a correction is a settings change, not a code change.
- Wati is tenant-hosted (`live-server-<id>.wati.io`), so its base URL will almost
  always need overriding regardless.

Zapup is the least publicly documented of the five; its profile follows the Meta
Cloud API schema that most small BSPs proxy, and should be treated as a starting
point.

## Verification notes

- Adapters: stub-server test covering all five profiles, plus retryable (500) vs
  permanent (400) classification and fail-fast on a missing credential.
- Editor: duotone matrix maths, indent round-trip and partial-selection
  behaviour, and connector routing/anchor-deletion checked against `fabric/node`
  — the same build the server-side renderer uses.
- Archive/restore, custom-field scoping and the API docs were each exercised
  end-to-end against the running API.
