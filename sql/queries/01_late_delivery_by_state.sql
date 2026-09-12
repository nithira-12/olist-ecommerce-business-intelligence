CREATE VIEW vw_late_delivery_by_state AS
SELECT 
    c.customer_state,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.order_delivered_customer_date::date > o.order_estimated_delivery_date::date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN o.order_delivered_customer_date::date > o.order_estimated_delivery_date::date THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS late_rate_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY late_rate_pct DESC;