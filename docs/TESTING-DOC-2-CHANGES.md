# BizzEngager Testing Doc — Change Checklist (round 2)

Source: `~/Downloads/Bizzengager Testing.pdf` (45 pages, client feedback round 2,
received 2026-08-22). Round 1 lives in [TESTING-DOC-CHANGES.md](TESTING-DOC-CHANGES.md).

Two items are **regressions** — they were signed off in round 1 and are back on the
list (R-marked below). Those need a repro first, not a rewrite.

Legend: `[ ]` open · `[x]` done · **[?]** needs an answer before it can be built.

## 1. Login / session

- [x] L1 **(R)** Remember Me does not work — round 1 item L2/A1 has regressed
      · `frontend/src/pages/auth/Login.jsx`, `lib/api.js`, `store/auth.jsx`
- [x] L2 Remember Me must default to **unchecked** · `Login.jsx`
- [x] L3 Super Admin and Admin can currently be signed in at the same time in one
      browser — signing into one panel must end the other's session
      · `store/auth.jsx` (token store is per-panel today), `ProtectedRoute.jsx`

## 2. Super Admin — Dashboard & Analytics

- [x] SD1 Add **All time** to the date-range presets on Dashboard *and* Analytics,
      and default the range to the **current month**
      · `components/DateRangeFilter.jsx`, `pages/superadmin/Dashboard.jsx`, `Analytics.jsx`
- [x] SA1 **(R)** Archived data must be excluded from analytics — round 1 item SA5
      · `backend/src/modules/superadmin/dashboard/*`

## 3. Super Admin — Companies

- [x] SC1 View Transactions: rename column **Particulars → Note**
      · `pages/superadmin/CompanyDetail.jsx` (+ any other table using the label)

## 4. Super Admin — Presets & Shapes

- [x] SP1 Horizontal scroll on the Add Preset page · `pages/superadmin/Manage.jsx`
- [x] SP2 Header layout on the same page is misarranged

## 5. Super Admin — Transactions / Invoicing

- [x] ST1 **Two invoice series with independent counters**, picked automatically:
      - Online `INV-O-2026-0001` — credits bought through the platform
        (`category: purchase`, `modules/admin/wallet/wallet.routes.js`)
      - Manual `INV-M-2026-0001` — credits assigned by an admin
        (`category: adjustment`, `superadmin/companies/company.service.js`)
      - Sequential per series per year; today `utils/ids.js` returns a random
        `INV-YYYYMMDD-nnnnnn`, so this needs a counter table + a transaction-safe
        allocator, plus a decision on what usage/refund rows get numbered with.
- [x] ST2 Rebuild the invoice to the layout in the doc (p20): logo + brand block,
      Paid badge, INVOICE FROM / INVOICE TO panels, item table
      (Item · Description · Quantity · Rate · Total), Subtotal / GST / Total,
      footer note · `backend/src/utils/invoicePdf.js`
- [x] ST3 Add the BizzEngager logo to the invoice · same file (needs an asset)
- [x] ST4 **All static invoice text editable from settings** — labels, company
      details, terms, footer — no code change to update them
      · new platform-settings section (`models/platform.js` already has a
      singleton) + a Settings tab + `invoicePdf.js` reading from it
- [x] ST5 Invoice export: add an **Invoice Type** filter (All / Online / Manual)
      alongside the existing filters
      · `modules/superadmin/transactions/transaction.routes.js`, `pages/superadmin/Transactions.jsx`

## 6. Super Admin — Credits

- [x] SCR1 **Element Credit Rules by range**: cost is configured per element-count
      band (1–5 → 3 credits, 6–10 → 5 credits, …). Needs validation that bands
      cannot overlap, repeat, or invert (`from > to`), and a defined behaviour for
      an element count above the last band
      · `backend/src/modules/wallet/elementCost.service.js`, `superadmin/credits/*`,
      `frontend/src/lib/creditRules.js`, `pages/superadmin/Credits.jsx`
      · **[?]** "as discussed in the meeting" — confirm the bands are inclusive and
      what happens past the top band (cap, or extrapolate).

## 7. Super Admin — Settings & permissions

- [x] SS1 One consistent error message style across every form
- [x] SS2 Hide sidebar entries the signed-in admin has no permission for
      · `components/layout/DashboardLayout.jsx`, permission list on `/auth/me`

## 8. Versions (superadmin)

- [x] V1 **View** button showing version details, including which tags it was
      fired for · `pages/superadmin/SettingsTabs.jsx` (versions tab)
- [x] V2 **Schedule a version**; scheduled ones can be viewed and deleted before
      they run · needs a scheduled-at column + a worker job
- [x] V3 Option to send the version notification **by email**
- [x] V4 Version users see all previously sent version-control notifications

## 9. Notifications (platform)

- [x] N1 **View** button listing every notification — scheduled, pending, sent,
      completed — plus **Delete** for scheduled ones before they fire
- [x] N2 Option to send a notification **by email**
- [x] N3 Show a user only notifications sent **after their registration date**
      · `backend/src/modules/admin/notifications/*`

## 10. Admin — Dashboard

- [x] AD1 Render an empty graph instead of hiding it when there is no data
      · `pages/admin/Dashboard.jsx`
- [x] AD2 Show the **credits balance** at the top of the page

## 11. Admin — Contacts

- [x] AC1 Import contacts: imported custom-field values were invisible
      afterwards — the contacts *list* never loaded them (only the single-contact
      read did), so the Edit form, seeded from the list row, showed every custom
      field blank. Fixed by eager-loading them in `listContacts`, which in turn
      needed `paginate` to blank *nested* include attributes (the two-level join
      broke MySQL's `only_full_group_by` in the id-paging phase).
- [x] AC2 Re-organize the Import CSV modal to match the doc's screenshot (p30)

## 12. Admin — Frame editor

- [x] AF1 Shadow: let the user set **shadow colour** and **shadow area**
      (blur/offset), not just on/off · `frame-editor/PropertiesPanel.jsx`,
      `useFabricEditor.js` (`toggleShadow` is a fixed preset today)
- [x] AF2 **Gradient** option for the background colour
- [x] AF3 Pencil (free-draw) size does not show the selected value
- [x] AF4 Offer the contact-field **mapping directly in the right-hand panel for
      every element**, and show the auto-filled value at save time
      · today mapping is a separate modal (`FieldMappingModal`)
- [x] AF5 Up / down arrow keys do nothing — no nudge shortcut is bound
      · `FrameEditorPage.jsx` keyboard handler
- [x] AF6 Ctrl/⌘ + scroll zoomed the whole browser instead of the canvas
      *(fixed 2026-08-22 — native non-passive wheel listener on the stage)*
- [x] AF7 Selection handles were clipped for objects overhanging the page
      *(fixed 2026-08-22 — 48px canvas bleed + page clip path)*

## 13. Admin — Media Gallery

- [x] AG1 Paginate at **12 items per page** · `pages/admin/Gallery.jsx`

## 14. Admin — Campaigns

- [x] ACa1 Scheduled date & time is missing from the **campaign details** page
      (the listing already shows it) · `pages/admin/CampaignDetail.jsx`
- [x] ACa2 Editing a scheduled campaign, clearing the schedule date and pressing
      Launch leaves it scheduled — it should launch immediately
      · `pages/admin/CampaignWizard.jsx`, `backend/src/modules/admin/campaigns/*`

## 15. Admin — Templates

- [x] AT1 Listing column **Image Type → Template Type**
- [x] AT2 Remove the separate Templates page (`/admin/templates`, `App.jsx:94`)
- [x] AT3 Once a Channel is chosen in the first dropdown, do not ask for it again
      in the second — the Templates section lost its own channel dropdown and now
      follows the page's channel filter plus the selected provider account
- [x] AT4 For WhatsApp, add **Template Category** and **Template Type** filters

## 16. Admin — Settings / Notifications page

- [x] AS1 New **Notifications page with two tabs**: *Notifications* (all) and
      *Versions* (version updates)
- [x] AS2 "What's New" opens it on the **Versions** tab
      · `components/layout/NotificationBell.jsx`
- [x] AS3 "View all notifications" opens it on the **Notifications** tab
- [x] AS4 Remove the notifications section from Settings · `pages/admin/Settings.jsx`

## Open questions

1. **SCR1 element bands** — inclusive ranges, and what applies above the top band?
2. **ST1 numbering** — usage and refund rows also carry an `invoiceId` today. Do
   they join the Manual series, or get a third series (e.g. `INV-U-`)?
3. **ST4 editable invoice text** — superadmin-only, or per-company overrides too?
4. **L3 single session** — should signing into the second panel force the first
   one out, or should the second sign-in be refused while a session is live?
