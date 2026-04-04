from app.database import engine
from sqlalchemy import text

def run_feature_pipeline():
    with engine.connect() as conn:

        with open("sql/feature_pipeline.sql") as f:
            query = f.read()

        conn.execute(text(query))

        max_id = conn.execute(
            text("SELECT MAX(event_id) FROM events")
        ).scalar()

        conn.execute(
            text("""
            UPDATE watermark
            SET last_event_id=:max_id
            WHERE pipeline_name='feature_pipeline'
            """),
            {"max_id": max_id}
        )

        conn.commit()

if __name__ == "__main__":
    run_feature_pipeline()