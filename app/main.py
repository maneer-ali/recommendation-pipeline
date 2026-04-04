from fastapi import FastAPI
from pydantic import BaseModel
from app.recommender import get_recommendations
import uuid
import time

app = FastAPI()

class RecommendRequest(BaseModel):
    customer_id: str
    surface: str
    limit: int
    exclude_product_ids: list[str]

@app.post("/api/v1/recommend")
def recommend(req: RecommendRequest):

    start = time.time()

    items = get_recommendations(
        req.customer_id,
        req.limit,
        req.exclude_product_ids
    )

    latency = int((time.time() - start) * 1000)

    return {
        "items": items,
        "model_version": "v1-cf-20260326",
        "decision_id": str(uuid.uuid4()),
        "latency_ms": latency
    }