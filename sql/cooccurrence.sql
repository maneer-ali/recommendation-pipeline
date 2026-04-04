INSERT INTO product_cooccurrence

SELECT
    a.product_id product_a_id,
    b.product_id product_b_id,
    COUNT(*) co_count,
    COUNT(*)::numeric /
    NULLIF((
        SELECT COUNT(*)
        FROM events
        WHERE product_id=a.product_id
    ),0) confidence,
    NOW()

FROM events a
JOIN events b
ON a.customer_id=b.customer_id
AND a.product_id<>b.product_id
AND a.event_time BETWEEN b.event_time - interval '30 days'
AND b.event_time + interval '30 days'

WHERE a.event_type='purchase'
AND b.event_type='purchase'

GROUP BY a.product_id,b.product_id
HAVING COUNT(*)>=1;