CREATE TABLE events (
    event_id SERIAL PRIMARY KEY,
    tenant_id TEXT,
    customer_id TEXT,
    session_id TEXT,
    product_id TEXT,
    category TEXT,
    event_type TEXT,
    amount NUMERIC,
    event_time TIMESTAMP
);

CREATE TABLE customer_features (
    customer_id TEXT PRIMARY KEY,
    total_views INT,
    total_cart_adds INT,
    total_purchases INT,
    distinct_products_viewed INT,
    distinct_categories_viewed INT,
    days_since_first_seen INT,
    days_since_last_activity INT,
    category_affinity JSONB,
    avg_days_between_purchases NUMERIC,
    total_revenue NUMERIC,
    avg_order_value NUMERIC,
    avg_session_duration NUMERIC,
    avg_products_per_session NUMERIC
);

CREATE TABLE watermark (
    pipeline_name TEXT PRIMARY KEY,
    last_event_id INT
);

INSERT INTO watermark VALUES ('feature_pipeline',0);

CREATE TABLE product_cooccurrence (
    product_a_id TEXT,
    product_b_id TEXT,
    co_count INT,
    confidence NUMERIC,
    last_updated TIMESTAMP
);

CREATE TABLE recommendation_log (
    decision_id UUID,
    customer_id TEXT,
    recommended_products JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);