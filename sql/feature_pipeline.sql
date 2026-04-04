WITH new_events AS (
    SELECT *
    FROM events
    WHERE event_id > (
        SELECT last_event_id
        FROM watermark
        WHERE pipeline_name='feature_pipeline'
    )
),

agg AS (
    SELECT
        customer_id,

        COUNT(*) FILTER (WHERE event_type='view') total_views,
        COUNT(*) FILTER (WHERE event_type='cart_add') total_cart_adds,
        COUNT(*) FILTER (WHERE event_type='purchase') total_purchases,

        COUNT(DISTINCT product_id) FILTER (WHERE event_type='view') distinct_products_viewed,
        COUNT(DISTINCT category) FILTER (WHERE event_type='view') distinct_categories_viewed,

        CURRENT_DATE - MIN(event_time::date) days_since_first_seen,
        CURRENT_DATE - MAX(event_time::date) days_since_last_activity

    FROM new_events
    GROUP BY customer_id
)

INSERT INTO customer_features (
    customer_id,
    total_views,
    total_cart_adds,
    total_purchases,
    distinct_products_viewed,
    distinct_categories_viewed,
    days_since_first_seen,
    days_since_last_activity
)

SELECT * FROM agg

ON CONFLICT (customer_id)
DO UPDATE SET
total_views = EXCLUDED.total_views,
total_cart_adds = EXCLUDED.total_cart_adds,
total_purchases = EXCLUDED.total_purchases;