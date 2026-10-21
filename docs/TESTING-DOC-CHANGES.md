# BizzEngager Testing Doc — Change Checklist

Source: `BizzEngager Testing Doc.pdf` (41 pages, client feedback round 1).

## 1. Global

- [x] G1 Consistent format for all form fields across the app
- [x] G2 Consistent date format across the app
- [x] G3 Same date-range filter everywhere (the Dashboard tab filter is the reference)
- [x] G4 Show **Date & Time** wherever only date is shown today
- [x] G5 Show/Hide password toggle on every password field
- [x] G6 Placeholders on all input fields
- [x] G7 Required `*` indicator on all mandatory fields
- [x] G8 Replace "Cr" with "Credit" everywhere

## 2. Login

- [x] L1 Single login form for Admin + Super Admin
- [x] L2 Remember Me checkbox
- [x] L3 Forgot Password flow
- [x] L4 Remove Company Code field
- [x] L5 Show/Hide password button
- [x] L6 Label: Email → Email Address
- [x] L7 Leading icons in email/password fields (mail + lock, per screenshot)
- [x] L8 "Don't have access? Contact Sales" link
- [x] L9 Contact Sales opens WhatsApp chat with +91 98799 66997

## 3. Super Admin — Dashboard

- [x] SD1 Add date-range filter (presets: Today, Yesterday, Tomorrow, This week, Last week, This month, Last month, This year + custom range)
- [x] SD2 Fix every filter so results are accurate

## 4. Super Admin — Analytics

- [x] SA1 Same filters as Dashboard
- [x] SA2 Most Active Companies: add Last Login Date
- [x] SA3 Low on Credits: add Last Credit Purchase Date
- [x] SA4 Add "Delivered Messages" box next to "Messages Sent"
- [x] SA5 Exclude archived data from analytics
- [x] SA6 Fix filters / verify data accuracy
- [x] SA7 Rename "Per-Company Breakdown" → "Company Performance Breakdown"
- [x] SA8 Sorting in Company Performance Breakdown; "Cr" → "Credit"
- [x] SA9 Column labels: Company Name, Frames, Broadcasts, Messages, Used Credits, Available Credits

## 5. Super Admin — Companies

### Account setup / password (public invite accept)
- [x] SC1 Show/Hide on both password fields
- [x] SC2 Password strength meter
- [x] SC3 Remove "By continuing you agree to BizzEngager's terms of service."
- [x] SC4 Add "I Agree to the Terms and Conditions" checkbox linking to the T&C page
- [x] SC5 Reword the setup banner + date format `DD/MM/YYYY`

### Company listing
- [x] SC6 20 companies exist, 19 render — "Acme Distributors" missing (pagination/count bug)
- [x] SC7 Move Add Tag button (per screenshot: top-right of Manage Tags modal)
- [x] SC8 Manage Tags table headers: Tag Name, Company Name, Created Date & Time, Actions
- [x] SC9 Listing labels: Company → Company Name, Owner → Owner Name, Used → Used Credits, Created → Created Date & Time, Actions

### Manage Invitations
- [x] SC10 Client Invitations → Company Invitations
- [x] SC11 "Search invitations..." → "Search by email or company…"
- [x] SC12 Credits → Credits Assigned
- [x] SC13 Expires → Invitation Expires

### Invite Company
- [x] SC14 Starting Credits → Credits Assigned After Registration
- [x] SC15 Placeholders on all fields
- [x] SC16 "Applied when they sign up" → "Tags Assigned Automatically After Registration"

### Add Company popup
- [x] SC17 Placeholders on all fields
- [x] SC18 Required `*` on mandatory fields
- [x] SC19 Keep the globally-required fields mandatory
- [x] SC20 Tags: multi-select dropdown with "Add New Tag"
- [x] SC21 Apply that tag-select control everywhere tags are chosen

### View Company
- [x] SC22 Details section: consistent field labels
- [x] SC23 Show Used Credits

## 6. Super Admin — Channel Config

- [ ] CC1 Changes per discussion with Divyaraj bhai — **needs clarification, not actionable from the doc**

## 7. Super Admin — Preset Management

- [ ] PM1 Changes as discussed with Divyaraj Bhai — **needs clarification**
- [x] PM2 Placeholders on all form fields
- [x] PM3 Remove the duplicate Edit button (two are shown)
- [x] PM4 Add "Actions" header label to the listing

## 8. Super Admin — System Logs

- [x] SL1 Fix search across all log sections
- [x] SL2 Login Logs: Company → Company Name, IP → IP Address, Date & Time
- [x] SL3 Campaign Logs: Company → Company Name, Date & Time
- [x] SL4 Error Logs: Company → Company Name, Date & Time

## 9. Super Admin — Transactions

- [x] ST1 Show Credit logs only; hide Credit Deduction logs
- [x] ST2 Labels: Company → Company Name, Date & Time, Actions

## 10. Super Admin — Credits

- [x] SCR1 Remove Packages functionality
- [ ] SCR2 Conversion Rate per meeting — **needs the agreed value**
- [ ] SCR3 Element Credit Rules per meeting — **needs the agreed values**

## 11. Super Admin — Settings

- [x] SS1 Disabled fields rendered lighter / clearly inactive
- [x] SS2 2FA: show a scannable QR code
- [x] SS3 Show/Hide on all password fields
- [x] SS4 Placeholders on all fields
- [x] SS5 Required `*` on mandatory fields
- [x] SS6 One consistent error-message format across forms
- [x] SS7 Hide sidebar items the user has no permission for
- [x] SS8 Custom Fields: dropdown for Company Tag selection
- [x] SS9 Custom Fields: add Created Date & Time column
- [x] SS10 Versions: dropdown for Company Tag selection
- [x] SS11 Versions: placeholders on all fields
- [x] SS12 Versions: consistent required-field error message
- [x] SS13 Versions: required `*` indicators
- [x] SS14 Versions labels: Version → Version Code, Name → Version Name, Date → Date & Time
- [x] SS15 Notifications: add scheduling options

## 12. Admin — Dashboard

- [x] AD1 Same filters as Super Admin Dashboard
- [x] AD2 "Cr" → "Credit"
- [x] AD3 Move Channel Integrations next to "Campaigns Over Time"

## 13. Admin — Contacts

- [x] AC1 Listing labels: Business → Business Name, Mobile → Contact Number, Added → Created Date & Time
- [x] AC2 Add Actions column header
- [x] AC3 Same field names in Contact Listing and View Contact
- [x] AC4 Add Contact: fix required-field validation for Custom Fields
- [x] AC5 Add an "All" option to the status filter (Active/Archived/All)
- [x] AC6 Fix Import Contacts
- [x] AC7 Restructure the Import CSV popup for readability
- [x] AC8 Tags listing: add Total Contacts column
- [x] AC9 Tags labels: Created → Created Date & Time, Tag → Tag Name

## 14. Admin — Frames

- [x] AF1 Manage Categories labels: Category → Category Name, Created → Created Date & Time

## 15. Admin — Billing

- [x] AB1 Transaction + Billing listings consistent with other pages, sticky header
- [x] AB2 Transactions: Type filter (Usage / Refund / All)
- [x] AB3 Add Campaign Name to Transaction History
- [x] AB4 Labels: Amount → Credits, Date → Date & Time

## 16. Admin — Campaigns

### Scheduling
- [x] CS1 Show Scheduled Date & Time in listing and detail
- [x] CS2 Stop/Cancel Schedule for scheduled campaigns
- [x] CS3 Delete for not-yet-executed campaigns
- [x] CS4 A cancelled schedule must never dispatch
- [x] CS5 Save as Draft, schedule later
- [x] CS6 Drafts editable until scheduled/executed
- [x] CS7 Draft → Scheduled transition shows Scheduled Date & Time
- [x] CS8 Status-driven row actions:
      Draft: Edit, Schedule, Delete · Scheduled: Edit/Reschedule, Stop/Cancel, Delete ·
      Executing: View Status/Progress · Completed: View Details/Reports · Cancelled: View Details, Delete

### Functionality & validation
- [x] CS9 Fix Schedule Campaign launch
- [x] CS10 Fix the whole scheduling flow
- [x] CS11 Fix required-field and workflow validation in the wizard
- [x] CS12 Select Channel: only show channels configured for the company
- [x] CS13 No channel configured → "Configure Channel" button → Channel Config page
- [x] CS14 Frame selection mandatory before next step
- [x] CS15 No frames → "Add Frame" button
- [x] CS16 Send Test: inputs for Frame field values and Template field values
- [x] CS17 After a test send, show the preview with filled values

## 17. Admin — Templates

- [x] AT1 Make "Add Template" fully functional
- [ ] AT2 Confirm template workflow with Divyaraj Bhai — **needs clarification**
- [x] AT3 Listing columns: Template Name, Image Type, Category, WhatsApp Service Provider, Date & Time
- [x] AT4 Row action: Delete

## 18. Admin — System Logs

- [x] AL1 Date Range filter on all log sections
- [x] AL2 Labels: IP → IP Address, Date → Date & Time
- [x] AL3 Campaign Logs: add Campaign Name column
- [x] AL4 Error Logs: add Campaign Name column

---

## Blocked / needs input

| Item | What's needed |
|---|---|
| CC1 | The Channel Config decisions from the Divyaraj discussion |
| PM1 | The Preset Management decisions from the Divyaraj discussion |
| SCR2 | The agreed credit conversion rate |
| SCR3 | The agreed element credit rules |
| AT2 | Confirmed template workflow |

---

## Root causes found behind the "not working" reports

These were real defects, not just missing UI. Each was reproduced before the fix
and re-checked after.

| Report | Root cause | Fix |
|---|---|---|
| SC6 — "20 companies, only 19 shown" | `paginate()` applied `LIMIT` to the **joined** row set (`subQuery: false` + a to-many `tags` include), so a company with two tags consumed two slots. `distinct: true` kept the *count* right at 20, so the page silently dropped rows. Reproduced: `limit=20` returned **11** rows while reporting 22. | Two-phase paging in `utils/pagination.js` — select the page's ids grouped by PK, then hydrate them. Affects every listing with a to-many include. |
| SL1 — "search doesn't work in logs" | The tables show a **Company** column, but `searchFields` never included the company name (only `email`/`message`). Searching what you can see returned nothing. | Search now spans every visible column, including the joined `$company.company_name$` and `$campaign.title$`. |
| AC6 — "Import Contact not working" | Re-importing a file returned `created: 0, errorCount: 1` and the UI showed a **green "Imported 0 contacts"** toast. The API never returned *why* rows were rejected, so a duplicate-only import looked like a silent failure. | API returns the per-row `errors`; the popup shows them in a table and no longer reports success when nothing was created. Also fixed a row-number off-by-one (`rows.indexOf` on a copied object always returned `-1` → "Row 0"). |
| CS9/CS10 — "Schedule Campaign not working" | `DateTimeField` emitted on each half independently: entering a **time first** discarded it (`onChange('')`), and entering a **date first** emitted `T00:00` — midnight today, already in the past — so the form rejected a schedule the user hadn't finished typing. | The field holds both halves until complete, and floors the time to `min` on the earliest allowed day. |
| CS11 — "validation not working" | `canNext = [title && !titleError, true, true, true, true][step]` — steps 2–5 were unconditionally passable, so the wizard walked to Launch with no frame, audience or provider and only failed at the end. | Per-step validation with the blocking reason shown inline; Launch re-checks every earlier step. |
| PM3 — "two Edit buttons" | The Brand Presets table set `rowActions` (Open in editor) *and* left `CrudPage`'s generic Edit on, because `fields` was non-empty. | `canEdit={false}` on that table. |

## Blocked — needs input before they can be built

| Item | What's needed |
|---|---|
| CC1 | The Channel Config decisions from the Divyaraj discussion |
| PM1 | The Preset Management decisions from the Divyaraj discussion |
| SCR2 | The agreed INR → credit conversion rate (the screen exists and saves; only the value is unknown) |
| SCR3 | The agreed element credit rules (same — the CRUD works, the rows are the question) |
| AT2 | Confirmation of the intended Template workflow |

## Judgement calls worth confirming

- **SC8** asked for a "Company Name" header on the Manage Tags table. That column
  holds a *count*, so it is labelled **Total Companies** (as the screenshot shows).
  The missing **Actions** header was added.
- **ST1** ("credit logs only") is enforced server-side as `direction: credit`, so
  purchases, refunds and manual assignments remain and per-campaign deductions
  are gone. The now-empty `usage` filter option was removed with it.
- **SCR1** removed the Packages management screen; the Add Credits flow buys by
  amount at the conversion rate.
- **G8**: `formatCredits()` now renders `1 Credit` / `500 Credits`. Where a label
  already reads "Credits", the value is a bare number so it doesn't stutter.
