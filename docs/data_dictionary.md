# Data Dictionary

Source: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
Real, anonymized commercial data covering ~100,000 orders (2016–2018) across
Brazilian marketplaces.

## Tables

### olist_customers_dataset
customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
> Note: `customer_id` is unique **per order**. `customer_unique_id` is unique
> **per person** — use this for repeat-purchase / person-level analysis.

### olist_orders_dataset
order_id, customer_id, order_status, order_purchase_timestamp,
order_approved_at, order_delivered_carrier_date, order_delivered_customer_date,
order_estimated_delivery_date

### olist_order_items_dataset
order_id, order_item_id, product_id, seller_id, price, freight_value

### olist_order_payments_dataset
order_id, payment_sequential, payment_type, payment_installments, payment_value
> Note: an order can have multiple payment rows (split payments) — aggregate
> per order_id before treating as total order value.

### olist_order_reviews_dataset
review_id, order_id, review_score, review_comment_title, review_comment_message,
review_creation_date, review_answer_timestamp
> Note: review text has partner/company names replaced with fictional names
> for anonymization. Review scores are real and unaffected.

### olist_products_dataset
product_id, product_category_name, product_weight_g, product dimensions

### olist_sellers_dataset
seller_id, seller_zip_code_prefix, seller_city, seller_state

### olist_geolocation_dataset
geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state

### product_category_name_translation
product_category_name (Portuguese), product_category_name_english

## Key Joins
| Join | Purpose |
|---|---|
| Orders + Customers | Customer location, repeat purchase analysis (via customer_unique_id) |
| Orders + Reviews | Delivery performance vs. satisfaction |
| Orders + Payments | Payment behavior |
| Orders + Order Items + Products | Revenue by category |
| Orders + Order Items + Sellers | Seller performance |
| Sellers/Customers + Geolocation | Map visuals |
