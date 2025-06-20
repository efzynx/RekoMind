# File: api/v1/api.py
from fastapi import APIRouter
from api.v1.endpoints import quiz, recommendations, history, admin, analysis
# api_router_v1 = APIRouter(prefix="/api/v1")

api_router = APIRouter()

# Sertakan router dari endpoints kuis & rekomendasi
api_router.include_router(quiz.router, prefix="/quiz", tags=["Quiz"])
api_router.include_router(recommendations.router, prefix="/recommendations", tags=["Recommendations"])

# Sertakan router dari endpoint history BARU
api_router.include_router(history.router, prefix="/history", tags=["History"]) 

# Tambahkan router lain jika ada
api_router.include_router(admin.router, prefix="/admin", tags=["Admin"])

# Router analysis
api_router.include_router(analysis.router, prefix="/analysis", tags=["Analysis"])