# Data Quality Report — Olist E-Commerce Marketplace

**Source notebook:** `notebooks/01_data_audit.ipynb`
**Data as of:** raw CSVs in `data/raw/` (untouched)
**Purpose:** Document what the initial audit found — structure, missing values,
duplicates, and early consistency checks — before any cleaning decisions are
made. This report describes *what exists*, not how it will be fixed. Cleaning
decisions and their reasoning belong in `docs/cleaning_log.md` (Phase 3).

---

## 1. Dataset Inventory

| Table | Rows | Columns |
|---|---|---|
| customers | 99,441 | 5 |
| orders | 99,441 | 8 |
| order_items | 112,650 | 7 |
| payments | 103,886 | 5 |
| reviews | 99,224 | 7 |
| products | 32,951 | 9 |
| sellers | 3,095 | 4 |
| geolocation | 1,000,163 | 5 |
| category_translation | 71 | 2 |

**Note on grain (row meaning):**
- `orders` is one row per order (99,441 orders).
- `order_items` (112,650) has more rows than `orders`, because a single order
  can contain multiple line items — this is expected, not an error.
- `payments` (103,886) also has more rows than `orders`, because a single
  order can be paid across multiple payment records (e.g. split between
  voucher + credit card). Any order-level revenue figure must aggregate
  payments by `order_id` first, or it will overstate order value.
- `geolocation` (1,000,163) is far larger than every other table because it's
  a reference table of zip-code-prefix → lat/lng combinations, not something
  tied 1:1 to orders, customers, or sellers.

---

## 2. Missing Values by Table

### customers — no missing values

### orders

| Column | Missing | % |
|---|---|---|
| order_approved_at | 160 | 0.16% |
| order_delivered_carrier_date | 1,783 | 1.79% |
| order_delivered_customer_date | 2,965 | 2.98% |

**Observation:** These three columns represent sequential stages of order
fulfillment (approved → handed to carrier → delivered to customer). The
`order_status` breakdown below shows 96,478 of 99,441 orders (97.0%) are
`delivered`, while the rest are in earlier or terminal-but-incomplete states
(`shipped`, `canceled`, `unavailable`, `invoiced`, `processing`, `created`,
`approved`). It's reasonable to expect that missing dates in these three
columns largely correspond to orders that never reached that stage — but this
has **not yet been formally verified against `order_status`**, and should be
checked explicitly in the cleaning notebook before deciding on treatment.

**order_status breakdown:**

| Status | Count |
|---|---|
| delivered | 96,478 |
| shipped | 1,107 |
| canceled | 625 |
| unavailable | 609 |
| invoiced | 314 |
| processing | 301 |
| created | 5 |
| approved | 2 |

### order_items — no missing values

### payments — no missing values

### reviews

| Column | Missing | % |
|---|---|---|
| review_comment_title | 87,656 | 88.34% |
| review_comment_message | 58,247 | 58.70% |

**Observation:** The large majority of reviews have no written title, and
over half have no written message — but `review_score` itself has no missing
values. This is consistent with normal review-platform behavior (most
customers leave a star rating without writing text). Missing comment text is
**not a data quality defect** — it should not be imputed or fabricated. It
does mean any text-based analysis (e.g. sentiment) will only be possible on a
minority of reviews.

### products

| Column | Missing | % |
|---|---|---|
| product_category_name | 610 | 1.85% |
| product_name_lenght | 610 | 1.85% |
| product_description_lenght | 610 | 1.85% |
| product_photos_qty | 610 | 1.85% |
| product_weight_g | 2 | 0.01% |
| product_length_cm | 2 | 0.01% |
| product_height_cm | 2 | 0.01% |
| product_width_cm | 2 | 0.01% |

**Observation:** The same 610 rows are missing category name and listing-text
metadata together, which suggests these are incomplete product listings
rather than random gaps — worth confirming by checking whether it's the exact
same 610 rows across all four columns. The 2 rows missing physical
dimensions are a separate, much smaller issue, likely a couple of individual
incomplete records rather than a systemic pattern.

### sellers — no missing values

### geolocation — no missing values

### category_translation — no missing values

---

## 3. Duplicate Rows

| Table | Duplicate rows |
|---|---|
| customers | 0 |
| orders | 0 |
| order_items | 0 |
| payments | 0 |
| reviews | 0 |
| products | 0 |
| sellers | 0 |
| **geolocation** | **261,831 (26.18% of all rows)** |
| category_translation | 0 |

**Observation — this is the most significant data quality issue found in the
audit.** Over a quarter of the geolocation table is exact duplicate rows.
Since geolocation is a reference table (zip-code-prefix → lat/lng/city/state,
not tied to a unique order or customer), duplication here doesn't corrupt any
transactional data, but it will inflate row counts and skew any aggregation
or join done against this table if not deduplicated first. It's also worth
checking, separately from exact duplicates, whether the *same zip code
prefix* legitimately maps to multiple slightly different lat/lng values
(which would be expected and not an error) versus truly identical rows
repeated.

---

## 4. Referential Integrity Checks

| Check | Result |
|---|---|
| `order_items.product_id` values not found in `products` | 0 |
| `order_items.seller_id` values not found in `sellers` | 0 |

**Observation:** No orphaned foreign keys were found between order_items and
its two parent tables. This is a good sign for building the relational
schema in PostgreSQL later — no rows will need to be dropped or investigated
purely for referential integrity reasons at this stage.

---

## 5. Value Sanity Checks

**Orders — delivery date logic:**
`order_delivered_customer_date < order_purchase_timestamp` → **0 rows**.
No orders show an impossible delivery-before-purchase date.

**Order items — pricing:**

| Check | Result |
|---|---|
| Rows with `price <= 0` | 0 |
| Rows with `freight_value < 0` | 0 |

`price` ranges from 0.85 to 6,735.00 (mean ≈ 120.65, median ≈ 74.99).
`freight_value` ranges from 0 to 409.68. A freight value of exactly 0 is
plausible (e.g. free-shipping promotions) and is not treated as an error at
this stage — it will be worth spot-checking a sample of these rows during
cleaning rather than assuming they're all legitimate.

---

## 6. Customer ID Structure

| Field | Unique values |
|---|---|
| `customer_id` | 99,441 (equals row count) |
| `customer_unique_id` | 96,096 |

**Observation:** `customer_id` is unique per row, confirming it is
effectively an *order-customer* key (one per order), not a person key.
`customer_unique_id` has fewer unique values than total rows, meaning
**3,345 rows involve a customer_unique_id that appears more than once** —
i.e., the same person placed more than one order. Any analysis of repeat
customers, customer lifetime value, or retention must group by
`customer_unique_id`, not `customer_id`.

---

## 7. Summary — Issues Ranked by Significance

| # | Issue | Table | Severity | Type |
|---|---|---|---|---|
| 1 | 26.18% duplicate rows | geolocation | High (volume) | Duplication |
| 2 | Missing delivery-stage dates, likely tied to order_status | orders | Medium | Missing data (probably legitimate) |
| 3 | Missing category + listing metadata (610 rows) | products | Low–Medium | Missing data, needs pattern check |
| 4 | Missing dimension data (2 rows) | products | Low | Missing data, isolated |
| 5 | Missing review title/message | reviews | Low | Missing data (expected, not a defect) |
| 6 | Repeat customers via customer_unique_id | customers | N/A | Structural note, not an error |

No critical structural defects (broken keys, impossible dates, invalid
prices) were found. The dataset is largely clean at the row level; the main
work in Phase 3 will be around **deduplication (geolocation)** and
**verifying, not assuming, the reasons behind missing values** before
deciding how to treat them.

---

## 8. Open Questions to Verify During Cleaning (not yet answered)

- Do the missing `order_approved_at` / `carrier_date` / `customer_date`
  values actually align with non-`delivered` order statuses, row for row?
- Is `product_category_name` missing on the *exact same* 610 rows as the
  other three product metadata columns, or is it a coincidence of similar
  counts?
- In `geolocation`, are the 261,831 duplicates truly identical rows, or does
  the same zip code prefix legitimately map to multiple close-but-different
  lat/lng pairs that only look like duplicates when rounded?
- Are `freight_value == 0` rows a real pattern (e.g. concentrated in certain
  sellers/categories) or scattered/random?

---

*This report reflects the actual output of `01_data_audit.ipynb` as run. No
cleaning actions have been taken yet — raw data in `data/raw/` remains
untouched.*
