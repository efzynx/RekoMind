# File: api/v1/endpoints/quiz.py

from fastapi import APIRouter, HTTPException, Query, Depends, Body
from typing import List, Optional
import uuid

from models.quiz_models import QuestionOut, QuizSubmission, QuizResult, QuizStartResponse, CategoryInfo
from services import quiz_service
from utils.opentdb_api import OPENTDB_CATEGORIES
from sqlalchemy.ext.asyncio import AsyncSession
try: from models.user_models import User, get_async_session
except ImportError: from db.session import get_async_session; from models.user_models import User # Fallback
from auth.core import fastapi_users

current_active_user = fastapi_users.current_user(active=True)
router = APIRouter()

@router.get("/categories", response_model=List[CategoryInfo], summary="Dapatkan Daftar Kategori Kuis")
async def get_available_categories():
    category_list = [ CategoryInfo(id=cat_id, name=cat_name) for cat_id, cat_name in OPENTDB_CATEGORIES.items() ]
    if not category_list: raise HTTPException(status_code=404, detail="Daftar kategori tidak ditemukan.")
    return category_list

@router.get("/start", response_model=QuizStartResponse, summary="Memulai Kuis Baru (Memerlukan Login)")
async def start_quiz(
    user: User = Depends(current_active_user),
    amount: int = Query(10, ge=1, le=50),
    category_ids: Optional[List[int]] = Query(None, alias="category_id"),
    difficulty: Optional[str] = Query(None, description="Pilihan: 'easy', 'medium', 'hard'", pattern="^(easy|medium|hard)$")
):
    print(f"[User: {user.email}] Starting quiz. Difficulty: {difficulty}, Categories: {category_ids}")
    quiz_session_id = str(uuid.uuid4())
    questions_for_user: List[QuestionOut] = await quiz_service.get_new_quiz(
        quiz_session_id=quiz_session_id, amount=amount, category_ids=category_ids, difficulty=difficulty
    )
    if not questions_for_user: raise HTTPException(status_code=503, detail="Gagal mengambil pertanyaan dari sumber eksternal.")
    return QuizStartResponse(session_id=quiz_session_id, questions=questions_for_user)

@router.get("/start-guest", response_model=QuizStartResponse, summary="Memulai Kuis Baru sebagai Tamu")
async def start_guest_quiz(
    amount: int = Query(10, ge=1, le=50),
    category_ids: Optional[List[int]] = Query(None, alias="category_id"),
    difficulty: Optional[str] = Query(None, description="Pilihan: 'easy', 'medium', 'hard'", pattern="^(easy|medium|hard)$")
):
    print(f"[Guest] Starting guest quiz. Difficulty: {difficulty}, Categories: {category_ids}")
    quiz_session_id = str(uuid.uuid4())
    questions_for_guest: List[QuestionOut] = await quiz_service.get_new_quiz(
        quiz_session_id=quiz_session_id, amount=amount, category_ids=category_ids, difficulty=difficulty
    )
    if not questions_for_guest: raise HTTPException(status_code=503, detail="Gagal mengambil pertanyaan dari sumber eksternal.")
    return QuizStartResponse(session_id=quiz_session_id, questions=questions_for_guest)

@router.post("/{quiz_session_id}/submit", response_model=QuizResult, summary="Submit Jawaban Kuis (Login)")
async def submit_quiz(
    quiz_session_id: str,
    submission: QuizSubmission = Body(...),
    user: User = Depends(current_active_user),
    db: AsyncSession = Depends(get_async_session),
):
    print(f"[User: {user.email}] Submitting quiz session {quiz_session_id}")
    result = await quiz_service.submit_quiz_answers(
        quiz_session_id=quiz_session_id,
        user_answers=submission.answers,
        db=db,
        user=user
    )
    if result is None:
        raise HTTPException(status_code=404, detail="Sesi kuis tidak valid atau telah kedaluwarsa.")
    return result

@router.post("/{quiz_session_id}/calculate-guest-result",
             response_model=QuizResult,
             summary="Hitung Hasil Kuis Tamu (Tanpa Login & Tanpa Menyimpan)")
async def calculate_guest_result(
    quiz_session_id: str,
    submission: QuizSubmission = Body(...)
):
    print(f"[Guest] Calculating result for session {quiz_session_id}")
    result = await quiz_service.calculate_guest_quiz_result(
        quiz_session_id=quiz_session_id,
        guest_answers=submission.answers
    )
    if result is None:
        raise HTTPException(status_code=404, detail="Sesi kuis tamu tidak valid atau telah kedaluwarsa.")
    return result