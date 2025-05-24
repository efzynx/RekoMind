# File: models/recommendation_models.py

from typing import List, Optional
from pydantic import BaseModel

# Impor skema yang dibutuhkan dari quiz_models
try:
    from .quiz_models import WeaknessAnalysis, IncorrectQuestionDetail
except ImportError:
    # Fallback jika dijalankan sebagai skrip tunggal atau struktur folder berbeda
    class WeaknessAnalysis(BaseModel): category_name: str; score_percentage: float; correct_count: int; total_questions: int # type: ignore
    class IncorrectQuestionDetail(BaseModel): question_id: str; question_text: str; user_answer: str; correct_answer: str; category_name: str; difficulty: str # type: ignore

class Recommendation(BaseModel):
    title: str
    summary: str
    url: Optional[str] = None
    source: str
    # score: Optional[float] = None # Opsional

class RecommendationRequestData(BaseModel): # Skema input untuk endpoint rekomendasi
    analysis: List[WeaknessAnalysis]
    incorrect_questions: List[IncorrectQuestionDetail]