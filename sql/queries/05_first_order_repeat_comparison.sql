-- Purpose: Compare first-order review score and delivery outcome between customers 
-- who eventually became repeat buyers vs. one-time buyers
-- Pillar: Customer Experience
-- Source tables: orders, customers, reviews

CREATE VIEW vw_first_order_repeat_comparison AS
WITH customer_order_rank AS (
    SELECT 
        o.order_id,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        c.customer_unique_id,
        ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS order_rank
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
),
first_orders AS (
    SELECT * FROM customer_order_rank WHERE order_rank = 1
),
customer_repeat_flag AS (
    SELECT customer_unique_id, COUNT(*) > 1 AS is_repeat_customer
    FROM customer_order_rank
    GROUP BY customer_unique_id
),
order_review AS (
    SELECT DISTINCT ON (order_id) order_id, review_score
    FROM reviews
)
SELECT
    crf.is_repeat_customer,
    COUNT(*) AS num_customers,
    ROUND(AVG(orv.review_score), 2) AS avg_first_order_review,
    ROUND(100.0 * SUM(CASE WHEN fo.order_delivered_customer_date::date > fo.order_estimated_delivery_date::date THEN 1 ELSE 0 END) 
        / NULLIF(SUM(CASE WHEN fo.order_delivered_customer_date IS NOT NULL THEN 1 ELSE 0 END), 0), 2) AS first_order_late_rate_pct
FROM first_orders fo
JOIN customer_repeat_flag crf ON fo.customer_unique_id = crf.customer_unique_id
LEFT JOIN order_review orv ON fo.order_id = orv.order_id
GROUP BY crf.is_repeat_customer;