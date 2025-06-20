# File: api/v1/endpoints/analysis.py

from fastapi import APIRouter, Depends, HTTPException
from typing import Optional
import uuid

from sqlalchemy.ext.asyncio import AsyncSession

# Router HARUS didefinisikan di luar try-except agar bisa diakses
router = APIRouter()

# --- Attempt Import Sesuai Struktur Proyek ---
try:
    from models.user_models import User, get_async_session
    from models.analysis_models import DeepAnalysisResult
    from services import analysis_service
    from auth.core import fastapi_users
except ImportError:
    # Fallback untuk pengembangan/testing
    User = type("User", (), {})
    DeepAnalysisResult = type("DeepAnalysisResult", (), {})

    async def get_async_session():
        yield

    class AnalysisService:
        async def perform_deep_analysis_for_user(self, user_id, db):
            return DeepAnalysisResult(
                user_id=str(user_id),
                summary_text="Error",
                weakest_concepts=[],
                example_incorrect_questions=[]
            )

    analysis_service = AnalysisService()

    class FastAPIUsers:
        def current_user(self, active):
            return lambda: None  # Dummy dependency

    fastapi_users = FastAPIUsers()

# Dependency untuk user aktif
current_active_user = fastapi_users.current_user(active=True)


@router.get(
    "/me",
    response_model=DeepAnalysisResult,
    summary="Dapatkan Analisis Kelemahan Mendalam untuk Pengguna Saat Ini"
)
async def get_my_deep_analysis(
    user: User = Depends(current_active_user),
    db: AsyncSession = Depends(get_async_session)
):
    """
    Menganalisis seluruh riwayat jawaban pengguna yang sedang login
    dan mengembalikan ringkasan kelemahan mereka.
    """
    if not user:
        raise HTTPException(status_code=401, detail="Otentikasi diperlukan.")

    try:
        analysis_result = await analysis_service.perform_deep_analysis_for_user(user.id, db)
        return analysis_result
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail="Gagal melakukan analisis mendalam.")
