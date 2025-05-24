# File: api/v1/endpoints/recommendations.py

from fastapi import APIRouter, Depends, HTTPException, Body
from typing import List, Optional

try:
    from models.recommendation_models import Recommendation, RecommendationRequestData
    from models.user_models import User
except ImportError:
    Recommendation = type("Recommendation", (), {}) # type: ignore
    RecommendationRequestData = type("RecommendationRequestData", (), {}) # type: ignore
    User = type("User", (), {}) # type: ignore

from services import recommendation_service
from auth.core import fastapi_users

router = APIRouter()
current_active_user = fastapi_users.current_user(active=True, optional=True)

@router.post( "/", response_model=List[Recommendation], summary="Dapatkan Rekomendasi Bacaan Berdasarkan Hasil Kuis" )
async def get_recommendations_based_on_analysis(
    request_data: RecommendationRequestData = Body(...),
    user: Optional[User] = Depends(current_active_user)
):
    user_email_for_log = user.email if user else "Guest"
    print(f"Endpoint: Received data for recommendations. User: {user_email_for_log}. IncorrectQs: {len(request_data.incorrect_questions)}, AnalysisCats: {len(request_data.analysis)}")
    if not request_data.incorrect_questions and not request_data.analysis:
        print("Endpoint: No data provided for recommendations.")
        return []
    try:
        recommendations = await recommendation_service.fetch_recommendations_from_quiz_result(request_data) # Panggil fungsi yang benar
        print(f"Endpoint: Returning {len(recommendations)} recommendations.")
        return recommendations
    except Exception as e:
        print(f"Endpoint: Error in get_recommendations_based_on_analysis: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Gagal menghasilkan rekomendasi: Terjadi kesalahan internal pada server.")