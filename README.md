# Executive Business Intelligence Analysis of Olist's Marketplace Performance

## Objective
Evaluate the overall health and performance of Olist's e-commerce marketplace,
and identify the biggest opportunities for improvement — built as a
decision-support analysis, not just a data exploration exercise.

## Business Pillars
Each pillar is analyzed using a consistent framework: **What happened? → Why
did it happen? → What should management do?**

1. **Revenue & Growth** — total revenue, trend, top categories/states, growth drivers
2. **Operations & Delivery** — delivery time, late delivery rate, regional bottlenecks
3. **Customer Experience** — review scores, satisfaction trends, delay-vs-review correlation
4. **Seller Performance** — top/bottom sellers, revenue concentration, fulfillment consistency

## Executive Summary
A single-page overview (Revenue, Orders, Customers, Avg Review, Avg Delivery
Time, Late Delivery %, Top Category, Top State, Key Insight, Key
Recommendation) sits in front of the four detailed pillar pages.

## Data Source
[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
— 9 relational tables, ~100k real, anonymized orders (2016–2018).

## Tech Stack
- **Python** (pandas, SQLAlchemy) — data loading & cleaning
- **PostgreSQL** — relational database, real schema with keys/joins
- **SQL** — business analysis queries (joins, CTEs, window functions)
- **Power BI** — dashboard & visualization
- **Git/GitHub** — version control

## Project Structure
```
olist-ecommerce-business-intelligence/
│
├── data/
│   ├── raw/                  # original, untouched CSVs from Kaggle
│   └── processed/            # cleaned datasets, ready for analysis
│
├── notebooks/
│   ├── 01_data_audit.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_exploratory_data_analysis.ipynb
│   └── 04_feature_engineering.ipynb
│
├── sql/
│   ├── schema/                # table creation, keys, constraints
│   ├── queries/                # business analysis queries
│   └── views/                  # reusable views
│
├── powerbi/
│   ├── dashboard.pbix
│   └── assets/
│
├── docs/
│   ├── business_understanding.md
│   ├── business_questions.md
│   ├── kpi_framework.md
│   ├── data_dictionary.md
│   ├── data_quality_report.md
│   ├── cleaning_log.md
│   └── business_report.md
│
├── images/
│   ├── dashboard/
│   ├── charts/
│   └── diagrams/
│
├── scripts/
│
├── README.md
├── requirements.txt
├── .gitignore
└── LICENSE
```

## Project Phases
1. Business & Data Understanding
2. Environment Setup, Dataset Understanding & Data Audit
3. Data Cleaning
4. Schema Design & Database Loading (SQL)
5. Feature Engineering
6. Exploratory Data Analysis (Python)
7. Business Analysis / SQL Querying
8. Dashboard Design & Build (Power BI)
9. Write-up, Recommendations & Publishing

## Key Data Notes
- `customer_id` is unique per **order**; `customer_unique_id` is unique per
  **person** — use the latter for repeat-purchase analysis.
- An order can have multiple rows in the payments table (split payments) —
  aggregate per `order_id` before treating it as order value.
- Review text has partner/company names replaced with fictional names; review
  **scores** are unaffected and fully usable.

## Executive Recommendations
_(To be completed at the end of the analysis — see docs/business_report.md)_

## Status
🔧 Phase 2 — Environment Setup & Data Audit (in progress)
