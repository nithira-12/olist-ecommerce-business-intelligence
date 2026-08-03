# KPI Framework

## Executive Summary KPIs
| KPI | Definition |
|---|---|
| Revenue | Sum of order item prices (+ freight, defined during feature engineering) |
| Orders | Count of distinct order_id |
| Customers | Count of distinct customer_unique_id |
| Avg Review Score | Mean of review_score |
| Avg Delivery Time | Mean(delivered date - purchase date) |
| Late Delivery % | % of orders where actual delivery date > estimated delivery date |
| Top Category | Highest-revenue product category |
| Top State | Highest-revenue customer state |

## Pillar-Level KPIs

### Revenue & Growth
- Revenue over time (monthly)
- Revenue by category (top/bottom N)
- Revenue by state

### Operations & Delivery
- Avg delivery time (overall, by state)
- Late delivery %
- Delivery time trend over time

### Customer Experience
- Avg review score (overall, by category)
- Review score distribution
- Review score vs. delivery delay correlation

### Seller Performance
- Revenue per seller (concentration — % of revenue from top 10% of sellers)
- Late delivery rate per seller
- Avg review score per seller

## Notes on Definitions
- Use `customer_unique_id` (not `customer_id`) for any person-level metric —
  see data_dictionary.md for why.
- Orders table can have multiple payment rows per order — aggregate before
  computing order-level value.
