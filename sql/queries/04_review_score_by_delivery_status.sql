-- Purpose: Average review score by delivery status (early/on_time/late/unknown)
-- Pillar: Customer Experience
-- Source tables: orders, reviews

CREATE VIEW vw_review_score_by_delivery_status AS
WITH order_review AS (
    SELECT DISTINCT ON (order_id) order_id, review_score
    FROM reviews
),
delivery_bucket AS (
    SELECT
        o.order_id,
        CASE
            WHEN o.order_delivered_customer_date IS NULL THEN 'unknown'
            WHEN o.order_delivered_customer_date::date < o.order_estimated_delivery_date::date THEN 'early'
            WHEN o.order_delivered_customer_date::date = o.order_estimated_delivery_date::date THEN 'on_time'
            ELSE 'late'
        END AS delivery_status
    FROM orders o
)
SELECT
    db.delivery_status,
    COUNT(db.order_id) AS total_orders,
    COUNT(orv.review_score) AS num_reviews,
    ROUND(AVG(orv.review_score), 2) AS avg_review_score
FROM delivery_bucket db
LEFT JOIN order_review orv ON db.order_id = orv.order_id
GROUP BY db.delivery_status
ORDER BY avg_review_score DESC;