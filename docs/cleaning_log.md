Issue: 610 products (1,603 order line items, R$179,535.28 / 1.32% of total revenue) were missing product_category_name and related listing metadata.
Why it matters: These are real sold products — leaving the category blank would cause them to disappear or get mishandled in any category-level revenue analysis.
Investigation: Confirmed all four missing columns were missing on the exact same 610 rows (one clean pattern, not four separate issues). Confirmed all 610 products were actually sold, representing 1.32% of total revenue — small enough not to distort analysis, but too large to ignore outright.
Decision: Filled product_category_name with "unknown" to preserve all sales in revenue/category analysis while being transparent about missing data. Left the other three listing-metadata columns (name length, description length, photo count) as null, since they don't affect revenue or category analysis.
Good — that confirms the fix worked, every product now has a category value.




Issue: 610 products (1,603 order line items, R$179,535.28 / 1.32% of total revenue) were missing product_category_name and related listing metadata.
Why it matters: These are real sold products — leaving the category blank would cause them to disappear or be mishandled in any category-level revenue analysis.
Investigation: Confirmed all four missing columns were missing on the exact same 610 rows (one clean pattern, not four separate issues). Confirmed all 610 products were actually sold, representing 1.32% of total revenue — small enough not to distort analysis, but too large to ignore outright.
Decision: Filled product_category_name with "unknown" to preserve all sales in revenue/category analysis while being transparent about missing data. Left the other three listing-metadata columns (name length, description length, photo count) as null, since they don't affect revenue or category analysis.




Issue: The geolocation table (1,000,163 rows) had 261,831 exact duplicate rows (26.18%), and was structured as many rows per zip code prefix (19,015 unique prefixes) rather than one.
Why it matters: This table exists to look up an approximate location for a zip code — it's not meant to be analyzed row-by-row. Carrying ~50 rows per zip code (many of them exact repeats) adds no value and bloats any join against it.
Investigation: Inspected sample duplicate rows directly. Found two distinct patterns: (1) genuine exact duplicates — same lat/lng/city/state repeated for no reason, and (2) multiple different but nearby lat/lng readings per zip prefix, which is expected since a zip code covers an area, not one exact point.
Decision: Removed exact duplicate rows first (1,000,163 → 738,332 rows), then collapsed to one representative row per zip code prefix by averaging lat/lng and taking the first listed city/state (738,332 → 19,015 rows). This produces a clean, analysis-ready lookup table with one row per zip code, suitable for joining to customers/sellers for state/city-level geographic analysis.




Issue: Loading the reviews table into PostgreSQL failed with an error saying a review_id value was duplicated. Checking further showed 789 review_ids that each showed up in 2 rows, so 1,603 rows total were affected.
Why it matters: review_id had been set up as the one thing that should be unique for each review. Simply deleting one of the two duplicate rows to fix the error would also delete a real order_id along with it — meaning an order that actually had a review would end up looking like it had no review at all in the database.
What was found: Looking at the actual duplicate rows side by side, the review score, comment text, and dates were exactly the same in both rows — the only thing different was the order_id. So this wasn't bad or broken data, it just meant the same review genuinely applied to two different orders.
What was done: Instead of deleting rows to force review_id to be unique on its own, the primary key was changed to the combination of review_id and order_id together — the same approach already used for order_items and payments, where one order can have multiple items or payments. This kept all 99,224 rows and didn't lose any real information, while still keeping the table properly structured.


Issue: While doing category revenue analysis , discovered that category_translation only had 1 row ("unknown") instead of 72. The original 71 real translations were missed during the Phase 4 database load — they weren't included in the table-loading list at the time.
Decision: Loaded the missing 71 rows from category_translation_clean.csv, bringing the table to its correct 72 rows.