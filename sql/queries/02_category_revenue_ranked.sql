CREATE VIEW vw_category_revenue AS
WITH category_revenue AS (
    SELECT 
        COALESCE(ct.product_category_name_english, 'unknown') AS category,
        SUM(oi.price) AS total_revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
    GROUP BY COALESCE(ct.product_category_name_english, 'unknown')
)
SELECT 
    category,
    total_revenue,
    ROUND(100.0 * total_revenue / SUM(total_revenue) OVER (), 2) AS pct_of_total_revenue,
    ROUND(100.0 * SUM(total_revenue) OVER (ORDER BY total_revenue DESC) / SUM(total_revenue) OVER (), 2) AS running_pct
FROM category_revenue
ORDER BY total_revenue DESC
LIMIT 15;