# Client change requests — August 2026

Source: client feedback list (verbal/notes). Each item below is the interpretation
plus the code area it touches. Items marked **[?]** need confirmation before work
starts; items marked **[meeting]** are parked for a discussion, not for coding yet.

**Status:** ✅ = done in this pass · ⏳ = blocked on an answer in "Open questions".

## Done in this pass

| # | Change | What changed |
|---|--------|--------------|
| A1 | Remember me | `lib/api.js` refreshed on 401 for every endpoint except the session-minting ones, so `/auth/me` no longer throws the session away when the 15-min access token expires; `store/auth.jsx` restores from a refresh token alone |
| A2 | Change password | New `POST /auth/change-password` (re-checks the current password, revokes other sessions, re-issues the caller's pair) + shared `ChangePasswordCard` on both security screens |
| A4 | 2FA scanner | Admin security tab now renders the QR image the API already returned |
| B2 | Admin login log | Superadmin sign-ins filtered out of the Login Logs tab (list + export); the tab and the company rows stay |
| B1 | Add Company dropdown | Tag picker menu is portalled to `<body>` with fixed positioning + flip-up, so the modal's scroll container no longer clips it |
| B3 | Company filter on logs | `CompanyFilter` on all three log tabs; the export honours it; filters clear on tab switch |
| B4 | Transactions | Refunds excluded server-side (category *and* refunded status); refund filter options removed; company filter added |
| C4 | Credit pricing | Config is now "1 Credit = ₹X" (`inrPerCredit`); purchase math multiplies instead of divides; an existing credits-per-rupee value is converted once on first read |
| C2 | Numeric credits | `formatCredits` returns a bare number; plan cards gained a "Credits" label |
| C3 | Credit note | Note field on Add Credits — becomes the transaction particulars (API already accepted it) |
| D1 | Template selection | Bulk "Sync" (which copied a provider's whole template list into the DB) replaced by `GET /templates/available` — a read-only browse of the provider's registry. Add Template now picks one from that list, prefills it from the provider definition and saves only that row. Campaigns already read from the DB, so they show only added templates |
| D2 | Campaign preview | Wizard previews and the test-send creative open in an `ImageLightbox` modal instead of a new browser tab |
| D3 | Delivery analytics | Read timestamp column dropped from the recipients table; status remains |
| E1 | Set as background | New editor action: cover-fits the selected image to the frame, sends it to back and locks it |
| E2 | Frame categories | Categories tab removed from Settings; inline creation in the editor toolbar is unchanged |
| F1 | SMS/Email templates | Channel Integration templates section is channel-scoped; `/templates/approved` takes a channel; the wizard offers templates for SMS and Email |
| F2 | View all | New `/admin/notifications` page (paged) linked from the bell and from Settings |
| F3 | Version notification | Publishing a version now fans out a platform notification to its rollout target |
| F4 | Emails | Made the silent failure loud (startup + per-send error logs). **Delivery still needs real SMTP credentials — see below** |
| G3 | Custom greeting | Superadmin sets the dashboard welcome line platform-wide (Settings → Greeting): a `{greeting}` / `{name}` template plus the three time-of-day phrases. Stored on a new `platform_settings` singleton, delivered on `/auth/me` so no screen needs an extra request |
| G1 | Pagination | Recipients table's page-size picker moved from the header into a bottom bar; every other listing already paged at the bottom |

## A. Auth & account

| # | Change | Where |
|---|--------|-------|
| A1 | "Remember me" on login must actually persist the session (checkbox exists, behaviour is wrong/not sticking) | `frontend/src/pages/auth/Login.jsx`, `frontend/src/lib/api.js` (tokenStore), `frontend/src/store/auth.jsx` |
| A2 | Add **Change password** for a logged-in user | `backend/src/modules/auth/*`, admin `Settings.jsx` + superadmin `SettingsTabs.jsx` |
| A3 | Split **Forgot password** flows for super admin and admin (separate entry points / separate handling) **[?]** | `backend/src/modules/auth/auth.controller.js`, `auth.routes.js`, `frontend/src/pages/auth/` |
| A4 | Security tab in **admin** is missing the 2FA **QR scanner** — it only prints the secret; superadmin shows a QR image | `frontend/src/pages/admin/Settings.jsx:183` vs `frontend/src/pages/superadmin/SettingsTabs.jsx:319` |

## B. Super admin — companies, logs, transactions

| # | Change | Where |
|---|--------|-------|
| B1 | Add Company: the dropdown pop-up must render properly (clipping / z-index / overflow issue) | `frontend/src/pages/superadmin/InviteClient.jsx`, `EditCompanyModal.jsx`, `components/Modal.jsx`, `CreatableSelect.jsx` |
| B2 | ✅ Login Logs no longer lists the platform admin's own sign-ins (the tab itself stays) | `backend/src/modules/superadmin/logs/logs.routes.js`, `frontend/src/pages/superadmin/Logs.jsx` |
| B3 | Add **company-wise filter** on Error Log and on Campaigns | `superadmin/Logs.jsx`, campaign listing + their routes |
| B4 | Transactions: do **not** show refund entries; add **company-wise filter** | `frontend/src/pages/superadmin/Transactions.jsx:64`, `backend/src/modules/superadmin/transactions/transaction.routes.js` |

## C. Credits & billing

| # | Change | Where |
|---|--------|-------|
| C1 | Credit handling in super admin "as per discussion" **[?]** — needs the discussion points spelled out | `backend/src/modules/superadmin/credits/`, `modules/wallet/credit.service.js` |
| C2 | Credit values must show **numeric only** — no text/label written after the number | `frontend/src/lib/format.js` (`formatCredits`), all credit displays |
| C3 | When adding credit, provide a **Notes** field so the reason for the grant is recorded (and visible later) | credit grant API + super admin credit UI, ledger model `backend/src/models/billing.js` |
| C4 | ✅ Configured as "1 Credit = ₹X" instead of "1 INR = X credits" | `frontend/src/pages/superadmin/SettingsTabs.jsx:524-547`, `backend/src/models/billing.js:57` |
| C5 | **Invoice PDF** must follow the client's given format; super admin must be able to edit the invoice template | `backend/src/utils/invoicePdf.js`, new superadmin template setting |

## D. Campaigns

| # | Change | Where |
|---|--------|-------|
| D1 | ✅ Templates are picked from the provider's list one at a time instead of bulk-synced | `frontend/src/pages/admin/CampaignWizard.jsx` |
| D2 | Campaign **preview** must open in a modal/pop-up, not as a Chrome URL/new tab | `CampaignWizard.jsx` / `CampaignDetail.jsx` preview action |
| D3 | Delivery analytics: show **status only**; remove the time shown under "Read" | `frontend/src/pages/admin/CampaignDetail.jsx`, `backend/src/modules/campaign/deliveryStatus.service.js` |

## E. Frame editor & design

| # | Change | Where |
|---|--------|-------|
| E1 | Frame editor: add **"Set as background"** action for a selected image/element | `frontend/src/pages/admin/frame-editor/PropertiesPanel.jsx`, `useFabricEditor.js`, `document.js` |
| E2 | ✅ Frame Categories removed from Settings; inline create in the editor toolbar kept | admin `Settings.jsx`, `frame-editor/Toolbar.jsx:32` |

## F. Channels, notifications, platform

| # | Change | Where |
|---|--------|-------|
| F1 | Channel Integration: show **template options for SMS and Email** (not just WhatsApp) | `frontend/src/pages/admin/Channels.jsx`, `backend/src/modules/admin/channels/` |
| F2 | Notifications: add a **"View all"** entry | notification bell component, `backend/src/modules/admin/notifications/notification.routes.js` |
| F3 | **Version notification** is not showing at all — fix it | `backend/src/modules/superadmin/platform/platform.routes.js`, notification delivery |
| F4 | **Emails are not being sent** — SMTP/mailer broken | `backend/src/utils/mailer.js`, env config |

## G. Cross-cutting UI

| # | Change | Where |
|---|--------|-------|
| G1 | Move **pagination to the bottom** of every list, consistently across all tables | `frontend/src/components/DataTable.jsx` and pages using it |
| G2 | Rename **field names coming from the backend** so the UI shows friendly labels **[?]** — which fields? | API response shapes / UI label maps |
| G3 | ✅ Superadmin sets it globally; template + per-slot phrases | `frontend/src/lib/greeting.js`, new platform/company setting |

## I. Reported separately

| # | Item | Status |
|---|------|--------|
| I2 | Tighter refresh for polling providers | ✅ Status polling is now two-tiered: a **fast sweep every 20s** over messages sent in the last 15 minutes (where nearly every delivered/read transition happens), plus the existing 5-minute full sweep as the backstop for late reads and scheduled notifications. Cost is bounded by messages actually in flight; capped at 300 rows per fast pass and guarded against overlapping runs. All four numbers are env-tunable (`STATUS_SYNC_FAST_INTERVAL_MS`, `STATUS_SYNC_HOT_WINDOW_MS`, `STATUS_SYNC_FAST_LIMIT`, `STATUS_SYNC_INTERVAL_MS`); set the fast interval to 0 to switch it off |
| I1 | Campaign send status (delivered/read) not updating in real time | ✅ Two client-side defects fixed: the socket pinned its access token at construction, so the first reconnect after 15 minutes failed the handshake and retried forever with a dead token; and the campaign room subscription was never re-sent on reconnect, so per-recipient events (emitted only to that room) stopped arriving. The socket now supplies a fresh token per attempt, re-subscribes on connect and refetches what it missed. Note the provider sweep itself runs every 5 minutes and **only while the campaign worker is running** |

## J. October 2026 batch

| # | Change | What changed |
|---|--------|--------------|
| J1 | ✅ Media section load speed (Frame Editor → Photos, Media Gallery) | Tiles used to download every full-size original (a 6 MB PNG per tile). The API now serves a 320px WebP at `/uploads/{cid}/thumbs/{file}.webp`, generated on first request by `backend/src/middlewares/thumbnails.js` and cached on disk — works for existing uploads too, no DB change (6 MB → 7 KB measured). Tiles fall back to the original if a thumbnail can't be made. The Photos tab keeps its last listing across tab switches, shows skeleton tiles while loading, lazy-loads/fades images in, and has a retry state |
| J2 | ✅ Campaign report download (CSV) | `GET /admin/campaigns/:id/report` — campaign details (channel, provider, template + type, frame, audience tags, dates) + delivery statistics (counts and rates, credits) + every recipient. `GET /admin/campaigns/report` — one row per campaign, honouring the list's search/status/channel/date filters. Buttons: **Download Report** on the Campaigns page header and campaign detail page, plus a download row action on non-draft campaigns |
| J2a | ✅ Campaign report as a two-sheet Excel file | Per client sample (MEETBHAI-campaign-report.xlsx): the single-campaign report is now `.xlsx` with a **Recipients** sheet (frozen bold header, phone numbers as text so they no longer show as 9.17874E+11, dates as real dates) and a **Campaign Details** sheet (details, then delivery statistics with real percentages). Times are in the campaign's (else company's) time zone. Filename `{campaign name}-dd-mm-yyyy-hh-mm-campaign-report.xlsx`, stamped at generation time; non-ASCII names survive via `filename*`. Streamed and keyset-paged. The all-campaigns list export stays CSV |
| J3 | ✅ Template type in template selection | Wizard dropdown reads `name — Image · Marketing`; the selected-template preview shows a type badge, category and language; the Review step shows the type next to the name. Type = header format (same as Channel Integration's "Template Type"), text when none |
| J4 | ✅ Custom Fields moved to Contacts | New **Contacts → Custom Fields** tab; removed from Settings. Same API and data — nothing migrated. The tab now checks the `contacts` permission, which is what the API already enforced (it used to check `settings`). Editor hints updated |
| J5 | ✅ Drag-and-drop image upload (Frame Editor → Photos) | Upload area accepts dropped files (several at once) as well as the picker, highlights while dragging, and lists each file with a progress bar and an Uploaded / Failed (with reason) line. Type and 15 MB size are checked before upload. A single file is still placed on the canvas; several go to the library only |
| J6 | ✅ Delete admin-created presets | Editor → Elements → Presets → **My Presets**: delete button on each tile (needs `frames:delete`), with a confirmation. Tiles are badged **Company** vs **Shared**; the Brand tab is labelled "Brand (shared)" and says it is read-only. API (`DELETE /admin/design/my-presets/:id`) already existed and is company-scoped |
| J7 | ✅ Photo cropping: free-form + shape | Crop mode now shows the whole photo dimmed with the kept area at full brightness. Frame resizes freely (or locks to Original / 1:1 / 4:5 / 4:3 / 16:9 / 9:16); dragging inside the frame pans the photo; a zoom slider scales it; Reset, Apply (also Enter or click away), Cancel (Esc). 12 crop shapes (circle, heart, star, hexagon…) become the photo's `clipPath`, which the server render honours. Select a photo + a canvas shape → **Crop image into this shape**. Re-opening a crop restores the full photo and the previous frame |
| J8 | ✅ Frame-creation workflow pass | A hint strip over the canvas explains the active tool/mode (text, pen, brush, eraser, point editing, crop) with a Done/Apply button; keyboard-shortcuts popover in the toolbar; plus J9–J12. More fixes to follow once the client's testing names specific friction points |
| J9 | ✅ Shape colour after adding text | Root cause: with the Text tab open, clicking a shape dropped a loose text box *on top* of it, so the shape could no longer be clicked. The text tool now writes *inside* the shape (shape+text group). Its panel separates **Shape color** from **Text color**, and has **Edit text** and **Separate** (split back into a shape and a text box) |
| J10 | ✅ Auto-fit text box | Text tab → **Auto-fit text box** (or the "Auto-fit text to box" toggle on any text box). Resize freely in either direction; the font grows/shrinks to fill the box, zero padding, live while dragging and typing. Box size is saved (`autoFit`, `boxWidth`, `boxHeight`); the server render applies the same patch, and refits personalised values (e.g. a long business name) inside the box. Verified editor PNG vs server PNG match |
| J11 | ✅ Pen tool with node editing | Toolbar pen (**P**): click = corner point, drag = curve, click the first point = closed filled shape, Enter/double-click = open path, Backspace = undo a point. **Edit points** (Properties, or double-click a pen path): drag points (handles follow) or handles, double-click the outline to add a point, select + Delete to remove, Smooth/Corner, Done/Esc/V to finish. Works on catalog shapes too. Paths are plain fabric paths, so they save and server-render as usual. The old pencil stays as the free-draw brush |
| J12 | ✅ Selection tool + **V** | Select button + V already existed; V is now ignored in inputs, dropdowns and live text, and while key-repeating; V also ends pen drafting and point editing. Verified: V in the frame-name field types "v", V inside canvas text types "v" |
| J13 | ✅ Save without leaving the Frame Editor | Save / Ctrl+S now saves in place (frames, brand presets and library shapes) with a "Frame saved" toast and the button flipping to **Saved**; the selection is kept (the thumbnail export used to drop it). A first save puts the new id in the URL without a router navigation, so the canvas and undo history survive and a repeat save updates instead of creating a duplicate (shapes used to). The field-mapping dialog only opens when an element is still unmapped and hasn't been reviewed this session; **Map fields** in the toolbar opens it any time. Back is the only exit, and asks first when there are unsaved changes |
| J14 | ✅ Add Company autofill + validation | Cause: **browser autofill**, not app state (the form starts empty). Chrome's password manager treats the field before a password box as the username, so it put the superadmin's saved email into Mobile Number and their saved password into Password. Fields now use `autocomplete="off"`, the password `new-password` (plus 1Password/LastPass opt-outs), the form resets every time it opens, and Mobile Number is `type="tel"`. Mobile numbers must be digits with an optional + country code (separators allowed): an email gets "looks like an email address — enter a phone number". Same rule server-side on create/update company, invite, invite sign-up and account settings |
| J15 | ✅ No horizontal scroll on Companies list | Fits from ~1255px wide with the sidebar open (was 1920px): used credits shown under the balance, date over time, long emails wrap, square icon actions, and the duplicate Add-credits icon removed (the Credits cell's **+ Add** stays, now permission-gated like the icon was). Narrower than that, rows become stacked cards instead of scrolling sideways (new opt-in `stackBelow` on DataTable) |

## K. Client feedback on the October batch (received 2026-10-24)

The client replied to J1–J12 point by point; items 3 and 9 needed no change.
Numbers below are the client's.

| # | Feedback | What changed |
|---|----------|--------------|
| K1 | Photos tab slow on tab switch; add a preview | The side panels now stay mounted once opened (hidden with CSS), so switching back to Photos is instant and nothing re-downloads; tiles that have painted once no longer replay the fade-in. Every tile has a hover **Preview** (magnifier) that opens the full-size image in the app's lightbox — My Uploads and Unsplash |
| K2 | Report file name not as required | Two causes. The API never exposed `Content-Disposition` through CORS, and in production the frontend (`v2.bizzengager.com`) and API (`v2.api.bizzengager.com`) are different origins — so the browser could not read the name and fell back to `campaign-{id}-campaign-report.xlsx`. Fixed with `exposedHeaders`. The name itself is now exactly the client's sample, `{campaign name}-campaign-report.xlsx`; the date/time stamp moved off the filename (it is on the Campaign Details sheet) |
| K4 | Superadmin field "for all companies" not visible in company accounts | The field *was* on contacts, in the import and in the editor's field pickers (those read `/available`), but **Contacts → Custom Fields** listed company-made fields only, which is where the client looked. That list now includes the platform-wide fields aimed at the company, badged **Platform** and read-only ("Set by the platform" instead of edit/delete). `GET /admin/custom-fields` returns both with a `readOnly` flag |
| K5 | Can't drop an image on the canvas or on the Media tab | Image files from the desktop can be dropped **straight onto the canvas**: uploaded to My Uploads, then placed at the drop point (several at once fan out; a single one dropped onto a shape fills it — see K7). The whole Photos panel is a drop zone now, not only the dashed box; both show a drop highlight. Type and 15 MB checks as before |
| K6 | Preset thumbnails missing; SVG files into the Shape Library; Brand Presets throw a fabric error | **Fabric error:** a brand preset is saved by the superadmin's editor as a whole frame document (`pages` + header/footer), but insert treated it as a bare object list, so every brand preset failed; insert now flattens a document, `{ objects }` or an array, and an empty preset says so instead of erroring. **Thumbnails:** "Save as Preset" never produced one — the selection is now rendered off-screen to a PNG, uploaded and stored as the tile; tiles show the whole graphic (contain, not cover) and the superadmin's preset list gained a thumbnail column. **SVG:** Elements → Shape Library has **Upload SVG files to the library** (several at once; company shapes for a company, the shared library in the superadmin editor), and the superadmin's Upload SVG now refreshes the list instead of asking to reopen the tab |
| K7 | Replaced photo not shown in the Photos tab; put the photo *in* the shape instead of crop-with-shape | **Live refresh:** Replace image, Fill with photo, canvas drops and the Media Gallery all signal the Photos tab, which refetches at once. **Photo into shape:** with a shape selected, clicking a photo (My Uploads or Unsplash) puts it inside the shape; so does dragging a photo (or a desktop file) and dropping it on a shape; a selected shape also has **Fill with photo** in Properties. The photo is cover-fitted to the shape and clipped by its outline in one step — no crop session — and saves/renders like a cropped photo (verified editor PNG = server PNG). "Crop image into this shape" remains for manual framing |
| K8 | Editor needs refinement: a Tools section in the side menu; close the side panels | New **Tools** tab (first in the rail): Select, Text, Pen, Brush, Eraser — each named, with a description and its key (V/T/P/B/E) — plus brush colour/size, Find & replace, Crop photo, Map contact fields and an inline shortcuts list. The header lost that run of icons and keeps undo/redo, zoom, grid, margins, guides, header/footer and the actions. Any side panel closes: click its tab again or the × in its corner; the rail shows **Open** while it is closed |
| K10 | Adding a text field "takes a predefined field" | Text from the Text tab (Heading, Subheading, Body, Text box, Auto-fit, "Add plain text box") now opens straight into editing with the placeholder selected, so the first keystroke replaces it; a box left empty is removed. Nothing is mapped to a contact field unless chosen |
| K11 | Make a shape empty by default | Every shape from the catalog, the primitives and a closed pen path lands as an outline with no fill. The old violet is kept as `lastFill`, so the Fill colour or "No fill (on)" brings a fill back in one click. A label written on an empty shape uses dark ink (it was always white, which vanished on an empty shape); on a filled shape the ink follows the fill's brightness |
| K12 | Tool switching not working as expected, mainly with text | The text tool was "sticky": with the Text tab open it stayed armed, so every canvas click made another empty box and an existing text box could not be selected or moved without pressing V. It is **one-shot** now — place a box, type, and the canvas is back on Select; a single click on a text box selects it, a double-click edits. Opening the Text tab no longer arms anything; the tool is armed from the Tools tab, the T key, or the line at the top of the Text tab. Picking a tool while a caret is live closes that edit first |

Verified headlessly (Playwright + Chrome against the dev servers): 36 checks across K1, K4–K8, K10–K12, plus editor-vs-server render parity for an empty shape, a labelled shape and a photo clipped into a circle.

## L. Client change tracker — October 2026 (Google Sheet, 57 rows, received 2026-10-27)

Source: the client's "Change Tracker" sheet. Numbers are the sheet's Change IDs. The filled
developer columns are in `docs/BizzEngager-Change-Tracker-dev-update.xlsx` (and
`docs/change-tracker-dev-columns-E-G.tsv` to paste into E:G of the live sheet).
Rows 5, 7, 9–12, 19–22 were already delivered in batch K (not yet seen by the client — deploy).
**Deploy note:** run `deploy.sh --sync` — `api_keys.expires_at` is a new column.

| # | Change | What changed |
|---|--------|--------------|
| L1/L57 | "Super Admin Panel Is Open in This Browser" page | Removed the cross-tab panel lock (`lib/panelLock.js` gone). Signing into one panel still ends the other's session (tokens cleared + a `be_signin` beacon other tabs hear via `storage`), but a tab in the other panel now just lands on `/login`. The lock had outlived sessionStorage sessions, so the page appeared with nothing open elsewhere |
| L2 | "Missing access token" rendered inside a page | A 401 with no refresh token (session cleared elsewhere) now clears the slot and redirects to `/login` |
| L3 | Empty chart grey box on hover | `ChartFrame` is `pointer-events-none` when there is no data (the box was the Recharts tooltip cursor) |
| L4/L28 | Date filter in download names | `backend/src/utils/filenames.js` (`datedFilename`, `dmyhm`) used by logs/transactions/wallet/invoices-zip/campaign exports; frontend `lib/filenames.js` for the analytics CSV and fallback names. `name-dd-mm-yyyy-to-dd-mm-yyyy`, or `name-all-time-till-<today>` |
| L8 | Campaign report name | Back to `{campaign name}-dd-mm-yyyy-hh-mm-campaign-report.xlsx` (campaign time zone); recipients CSV also stamped |
| L6/L50 | Toolbar control heights | SearchInput, ListFilters, CompanyFilter and DateRangePicker trigger are all h-10 |
| L13/L17 | Browser confirm() dialogs | `components/ConfirmDialog.jsx`: `confirmDialog({ title, message, confirmLabel, danger })` promise + `<ConfirmHost/>` in App. All 17 `confirm()` calls replaced with specific titles/messages; 2FA-disable `prompt()` is a password modal |
| L14 | Error logs panel on superadmin dashboard | `/superadmin/dashboard` returns `errors: { count, recent[8] }`; panel with link to System Logs |
| L15 | Permissions "All" column | Superadmin matrix uses a checkbox (was a "set" link) |
| L18/L46 | Category dropdown scroll | `CreatableSelect` menu is portalled to body with fixed positioning (flip-up, reflow on scroll/resize, Esc closes) |
| L23 | Rate limit "must be a number" on update | CrudPage/ManageList send `null` for a blank optional number and `Number()` otherwise |
| L24 | Preset status UI | Labelled Status select (Draft/Published/Archived) in the editor header |
| L25 | Upload SVG button | Same `Button` as Design Shape, hidden file input |
| L26 | Preset tile sizes | Fixed `h-24` preview box, image `object-contain` |
| L27/L33 | Canvas extra scroll | Stage is `overflow-hidden` until page+rulers+padding exceed it (the fabric control-margin ring overhang counted as scrollable area); fit-to-screen subtracts the 22px rulers |
| L32 | Library filters | Presets: status/categoryId/audience; Shapes: category (new `GET /superadmin/library/shapes/categories`) |
| L34 | Grid | Drawn on the canvas in `after:render` (page units, major every 5th), spacing select 10–100px; CSS stage grid removed |
| L36/L37 | Channel provider form | `GET /superadmin/channel-providers/catalog` (`providers/catalog.js`: Meta, BizzRiser, BSP profiles, SMTP, SMS gateways flagged `simulated`). Provider Name is a select; picking one pre-fills base URL + per-adapter endpoint fields (`endpoints` JSON) and rate. CrudPage custom fields get a 4th `setMany` arg |
| L38 | Sidebar toggle | State in localStorage, tooltips when collapsed, overlay + backdrop below lg |
| L40 | Login footer | "Contact Support" |
| L41 | Format painter | One-shot: `armFormatPainter()` copies, next `selection:created/updated` pastes and disarms; `painting` state drives the hint strip and button; Esc disarms |
| L42/L45 | Version / notification submit | `submitLabel`/`scheduleLabel` on `TargetedListPage`: Launch / Schedule Launch, Send / Schedule |
| L43 | Add Company | Button + `CreateCompanyModal` removed; Invite Client is primary |
| L44 | Toast wording | CrudPage/ManageList `itemLabel` (from createLabel) → "Provider saved"; specific messages in Settings, SettingsTabs, IntegrationsTabs |
| L47 | Notification read not real time | `lib/notifications.js` (window event + BroadcastChannel) links the bell and the page across tabs; optimistic badge update |
| L48 | Custom canvas size | Toolbar "Custom" + W×H inputs (100–8000); `aspectRatio: 'custom'` with width/height saved; Frames size filter gained Custom |
| L49 | Add Template manual option | Segmented "Choose from provider / Enter manually" |
| L51 | Logs tab change | Clears search + date params and remounts the controls (admin + superadmin) |
| L52 | "member" role label | Role column: real role / "No role"; Access "Custom permissions" |
| L53/L54 | Team/role forms | Inline required errors; role (and custom member perms) need ≥1 permission; API `roleSchema` refuses empty |
| L55/L56 | API keys | `expiresAt` column; create accepts `expiresAt`; `resolveApiKey` refuses expired; `POST /:id/revoke` + hard `DELETE /:id`; UI Expires column, expiry picker, Revoke vs Delete |

**Needs client input (sheet rows 16, 29, 30, 31, 35, 39):** production SMTP credentials
(`SMTP_HOST/PORT/USER/PASS`, `MAIL_FROM`) — every "email not sent" report has that one cause;
which SMS gateway + account (there is still no live SMS adapter, sending is simulated);
Razorpay live keys for "set payment gateway".

Verified: API checks (catalog, categories, dashboard errors, export filenames, provider update
with null/'' rate, role validation, API key create/expiry/revoke/delete) and 29 headless-browser
checks (Playwright + Chrome) covering L1, L2, L6, L13–L15, L18, L24, L27, L32, L34, L36, L37,
L41–L43, L45, L48, L50, L53–L56.

## H. Parked for meeting

| # | Item |
|---|------|
| H1 | **[meeting]** Batch handling — to be reviewed with Divyraj bhai |
| H2 | **[meeting]** Version & notification behaviour — to be reviewed in the meeting |

## Open questions

1. **A3** — Separate how? Different reset URLs/pages per role, separate email templates, or super admin reset handled manually instead of self-service?
2. **C1** — What exactly was agreed in the discussion about credits in super admin?
3. **C5** — Is there a sample invoice PDF from the client to match? Which fields must the super admin be able to edit?
4. **G2** — Which backend field names are wrong, and what should they read as?
