from sqlalchemy import text
from app.database import engine

def get_recommendations(customer_id, limit, exclude):

    with engine.connect() as conn:

        affinity = conn.execute(text("""
        SELECT category_affinity
        FROM customer_features
        WHERE customer_id=:cid
        """), {"cid": customer_id}).fetchone()

        if affinity and affinity[0]:

            products = conn.execute(text("""
            SELECT DISTINCT product_id, 0.7 as score, 'category_affinity' as reason
            FROM events
            WHERE category IN (
                SELECT jsonb_object_keys(category_affinity)
                FROM customer_features
                WHERE customer_id=:cid
            )
            LIMIT :limit
            """), {"cid": customer_id, "limit": limit}).fetchall()

        else:

            products = conn.execute(text("""
            SELECT product_id, COUNT(*) score, 'global_popularity' as reason
            FROM events
            GROUP BY product_id
            ORDER BY COUNT(*) DESC
            LIMIT :limit
            """), {"limit": limit}).fetchall()

        return [
            {
                "product_id": p[0],
                "score": float(p[1]),
                "reason": p[2]
            }
            for p in products if p[0] not in exclude
        ]