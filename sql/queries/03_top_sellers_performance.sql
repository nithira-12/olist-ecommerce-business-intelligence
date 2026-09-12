CREATE VIEW vw_seller_performance AS
WITH seller_orders AS (
    SELECT DISTINCT oi.seller_id, oi.order_id
    FROM order_items oi
),
seller_delivery AS (
    SELECT 
        so.seller_id,
        COUNT(*) AS total_orders,
        SUM(CASE WHEN o.order_delivered_customer_date::date > o.order_estimated_delivery_date::date THEN 1 ELSE 0 END) AS late_orders
    FROM seller_orders so
    JOIN orders o ON so.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY so.seller_id
),
seller_revenue AS (
    SELECT seller_id, SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)
SELECT 
    sr.seller_id,
    sr.total_revenue,
    sd.total_orders,
    sd.late_orders,
    ROUND(100.0 * sd.late_orders / sd.total_orders, 2) AS late_rate_pct
FROM seller_revenue sr
JOIN seller_delivery sd ON sr.seller_id = sd.seller_id
ORDER BY sr.total_revenue DESC
LIMIT 10;