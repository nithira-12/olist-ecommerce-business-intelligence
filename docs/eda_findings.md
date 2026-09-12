# EDA Findings Log

## Delivery & Operations

### Finding: Late Delivery Strongly Damages Customer Satisfaction
89.1% of orders arrive earlier than the estimated delivery date, and only
6.6% arrive late — but the impact of that 6.6% is severe. Late orders
average a review score of 2.27/5, compared to 4.29/5 for early orders and
4.03/5 for on-time orders — a drop of roughly 2 full points. Late deliveries
are not evenly distributed: states like Bahia (11.72% late rate, 3,380
orders) and Rio de Janeiro (11.63%, 12,852 orders) show meaningfully worse
performance than São Paulo (4.36%, 41,746 orders), Olist's largest and
best-served market. This suggests delivery performance in select
high-volume states is a concrete, addressable driver of customer
dissatisfaction.




## Customer Experience

### Finding: Low Repeat Purchase Rate, Not Explained by First-Order Delivery or Review Experience
Only 3.12% of customers (2,997 of 96,096) placed more than one order in the
2016–2018 window, contributing a modest 5.73% of total revenue. To test
whether a customer's initial experience predicts repeat purchasing,
first-order review scores and delivery outcomes were compared between
customers who eventually repeated and those who didn't. Neither showed a
meaningful difference: first-order review scores were nearly identical
(4.08 vs 4.11), and first-order late-delivery rates were similar (6.6% vs
5.4%). Within the available data, repeat purchasing does not appear to be
strongly associated with delivery or review experience on the first order.
The low repeat rate is more likely explained by factors outside this
dataset — such as competition, one-off purchase needs, or the dataset's
two-year window limiting visibility into later repeat behavior — rather
than service quality.




## Revenue & Growth

### Finding: Steady Revenue Growth Through 2017-2018, With a Clear Black Friday Spike
Total revenue across the dataset comes to R$13,591,643.70. Looking at the
full monthly trend, the very start (Sept-Dec 2016) and the very end
(Sept-Oct 2018) show almost no revenue — but this isn't a real business
pattern. Checking the purchase dates confirmed the dataset only properly
starts around January 2017 and cuts off partway through October 2018, so
those edge months are incomplete, not a genuine ramp-up or crash. Excluding
them, revenue climbs steadily from R$120,312 in January 2017 to a peak of
R$1,010,271 in November 2017 — roughly an 8x increase in under a year.
Breaking November 2017 down by day showed a clear reason for that peak:
November 24, 2017 (Black Friday in Brazil) alone brought in R$152,653.74,
more than double the next best day that month (Nov 25, R$60,923.48). This
confirms the November spike is a real, explainable one-day sales event
rather than random monthly noise, and shows Olist's marketplace saw
consistent underlying growth throughout 2017 and into mid-2018, on top of
a strong seasonal Black Friday effect.


### Finding: Revenue is Concentrated in a Core Group of Categories, Led by Health & Beauty
Out of 72 product categories, the top 10 account for 62.4% of total
revenue. Health & Beauty leads at R$1,258,681, followed by Watches & Gifts
(R$1,205,005) and Bed, Bath & Table (R$1,036,988). This shows a meaningful
but not extreme concentration — the marketplace isn't reliant on just one
or two categories, but a relatively small core group drives the majority
of sales, which is useful context for understanding where the business's
strength currently lies.


### Finding: Revenue is Heavily Concentrated in São Paulo and a Few Core States
The top 10 states account for 87.9% of total revenue — even more
concentrated than the category breakdown. São Paulo alone generates
R$5,202,955, over 38% of total revenue by itself, followed by Rio de
Janeiro (R$1,824,092) and Minas Gerais (R$1,585,308). This connects
directly to the earlier delivery finding: São Paulo also had the lowest
late-delivery rate (4.36%), while states with the worst delivery
performance (Bahia, Alagoas, Maranhão) are comparatively small revenue
contributors. This suggests Olist's core, most reliable market is
concentrated around São Paulo and a handful of populous neighboring
states, while its weaker-performing markets currently represent a
relatively small share of overall revenue — a useful consideration when
prioritizing where to invest in delivery improvements.



## Seller Performance

### Finding: Revenue is Broadly Distributed Across Sellers, With One Top Seller Showing a Delivery Gap That Doesn't Yet Affect Reviews
Unlike the strong revenue concentration seen by state (top 10 states =
87.9% of revenue), seller-level revenue is much more evenly spread: the
top 10 sellers (out of 3,095 total) account for only 13.1% of total
revenue, indicating a healthy, diversified seller base rather than
dependence on a few dominant sellers. Checking delivery performance among
the top 10 sellers found most performing in line with or better than the
company-wide 6.6% late rate. One exception stood out: the #1 seller by
revenue (R$229,472) had a 10.5% late rate, the highest among the top 10.
However, testing whether this translated into worse customer satisfaction
showed it did not — this seller's average review score (4.13, based on
1,132 orders) was actually slightly above the marketplace average (4.09).
This suggests the seller's higher late rate is a real operational gap
worth monitoring, but is not currently harming their reputation or
customer experience in a measurable way.