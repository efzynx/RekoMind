# File: api/v1/endpoints/analysis.py

from fastapi import APIRouter, Depends, HTTPException
import uuid

# --- BAGIAN 1: Impor Langsung (Dengan Path yang Benar) ---
from sqlalchemy.ext.asyncio import AsyncSession
from models.user_models import User, get_async_session # <-- PERBAIKAN: Impor get_async_session dari sini
from models.analysis_models import DeepAnalysisResult
from services import analysis_service
from auth.core import fastapi_users
# from api import deps # <-- HAPUS BARIS INI KARENA TIDAK DIGUNAKAN

router = APIRouter()

# --- BAGIAN 2: Dependency User ---
current_active_user = fastapi_users.current_user(active=True)

# --- BAGIAN 3: ENDPOINT UTAMA ---
@router.post("/summary", response_model=dict)
async def get_holistic_analysis_summary(
    current_user: User = Depends(current_active_user),
    # <<< PERBAIKAN: Gunakan 'get_async_session' sebagai dependency >>>
    db: AsyncSession = Depends(get_async_session)
):
    """
    Endpoint utama untuk mendapatkan analisis hybrid holistik dari layanan Colab.
    """
    if not current_user:
        raise HTTPException(status_code=401, detail="Otentikasi diperlukan.")

    try:
        analysis_data = await analysis_service.perform_deep_analysis_for_user(
            user_id=current_user.id,
            db=db
        )
        
        if isinstance(analysis_data, dict) and "error" in analysis_data:
            raise HTTPException(status_code=503, detail=analysis_data["error"])
        
        if hasattr(analysis_data, 'model_dump'):
            return analysis_data.model_dump()
            
        return analysis_data

    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Terjadi kesalahan internal: {e}")

# --- BAGIAN 4: ENDPOINT LAMA (DEPRECATED) ---
@router.get(
    "/me",
    response_model=DeepAnalysisResult,
    summary="[DEPRECATED] Gunakan POST /summary"
)
async def get_my_deep_analysis(
    user: User = Depends(current_active_user),
    # <<< PERBAIKAN: Gunakan 'get_async_session' di sini juga >>>
    db: AsyncSession = Depends(get_async_session)
):
    """
    Endpoint ini sudah usang. Gunakan POST /summary.
    """
    if not user:
        raise HTTPException(status_code=401, detail="Otentikasi diperlukan.")

    analysis_result = await analysis_service.perform_deep_analysis_for_user(
        user_id=user.id, 
        db=db
    )
    
    if not isinstance(analysis_result, DeepAnalysisResult):
         raise HTTPException(status_code=503, detail="Gagal mendapatkan analisis dalam format yang benar.")

    return analysis_result
