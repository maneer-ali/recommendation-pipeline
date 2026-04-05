# Recommendation Pipeline

## Project Overview

This project implements a lightweight recommendation system that:

* Ingests customer event data into PostgreSQL
* Builds customer behavioral features
* Computes product co-occurrence relationships
* Serves recommendations through a FastAPI endpoint

The system is designed as a modular recommendation pipeline that demonstrates:

* Feature engineering
* SQL-based recommendation logic
* API serving layer
* Logging and reproducibility

---

# Project Architecture

```text
Events Table
   ↓
Feature Pipeline (pipeline.py)
   ↓
customer_features
   ↓
Product Co-occurrence SQL
   ↓
product_cooccurrence
   ↓
FastAPI Recommendation API
```

---

# Tech Stack

* Python 3.x
* PostgreSQL
* FastAPI
* SQLAlchemy
* Uvicorn

---

# Project Structure

```text
recommendation-pipeline/
│
├── app/
│   ├── main.py
│   ├── pipeline.py
│   ├── recommender.py
│   ├── database.py
│   ├── schemas.py
│
├── sql/
│   ├── init_tables.sql
│   ├── cooccurrence.sql
│
├── README.md
```

---

# Database Setup

## Create Database

Run in PostgreSQL:

```sql
CREATE DATABASE recommendation_db;
```

---

## Run Table Creation Script

From terminal:

```bash
& "C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres -d recommendation_db -f sql/init_tables.sql
```

---

# Sample Data Insertion

Run sample events manually:

```sql
INSERT INTO events
(tenant_id, customer_id, session_id, product_id, category, event_type, amount, event_time)

VALUES
('t1','cust_1','s1','prod_1','electronics','view',0,NOW()),
('t1','cust_1','s1','prod_2','electronics','purchase',500,NOW());
```

---

# Product Co-occurrence Computation

Run:

```bash
& "C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres -d recommendation_db -f sql/cooccurrence.sql
```

This populates:

* product_cooccurrence

---

# Feature Pipeline Execution

Run:

```bash
python -m app.pipeline
```

This populates:

* customer_features

---

# Run API

Start FastAPI server:

```bash
python -m uvicorn app.main:app --reload
```

Swagger UI:

```text
http://127.0.0.1:8000/docs
```

---

# API Endpoint

## POST /api/v1/recommend

### Request Body

```json
{
  "customer_id": "cust_1",
  "surface": "homepage_carousel",
  "limit": 8,
  "exclude_product_ids": []
}
```

---

## Sample Response

```json
{
  "items": [
    {
      "product_id": "prod_2",
      "score": 2.0,
      "reason": "global_popularity"
    }
  ],
  "model_version": "v1-cf-20260326",
  "decision_id": "generated-uuid",
  "latency_ms": 45
}
```

---

# Recommendation Logic

Current recommendation strategy:

## 1. Category Affinity

If customer category affinity exists:

* Recommend products from preferred categories

## 2. Global Popularity Fallback

If no affinity exists:

* Recommend most frequently occurring products globally

---

# Feature Engineering

Generated customer features include:

* total_views
* total_cart_adds
* total_purchases
* distinct_products_viewed
* distinct_categories_viewed
* total_revenue
* avg_order_value

---

# Notes

* Product co-occurrence uses purchase events only
* Threshold can be adjusted in `cooccurrence.sql`
* Watermark table controls incremental feature updates

---

# Future Improvements

* Exclude already purchased products
* Add collaborative filtering
* Add ranking model
* Add batch scheduler
* Add cloud deployment

---


<img width="1912" height="949" alt="Screenshot 2026-04-04 234614" src="https://github.com/user-attachments/assets/d3d9deda-917a-4017-9acb-528059adceb4" />



<img width="1863" height="963" alt="Screenshot 2026-04-04 234551" src="https://github.com/user-attachments/assets/fb2666bc-78eb-46da-a739-dda3341f1da2" />


