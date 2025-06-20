# File: services/admin_service.py (File BARU)

import csv
import io
from typing import List, Dict, Any
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload

try:
    from models.history_models import UserAnswerDetail, QuizAttempt
    from models.user_models import User
except ImportError:
    UserAnswerDetail = type("UserAnswerDetail", (), {}) # type: ignore

async def get_all_answer_details_as_csv(db: AsyncSession) -> str:
    """
    Mengambil semua detail jawaban dari database dan mengkonversinya ke string CSV.
    """
    # Query untuk mengambil semua detail jawaban, dan pre-load data attempt & user
    # Ini bisa sangat berat jika datanya besar. Pertimbangkan paginasi atau streaming di masa depan.
    # stmt = (
    #     select(UserAnswerDetail)
    #     .options(
    #         selectinload(UserAnswerDetail.quiz_attempt).selectinload("user")
    #     )
    #     .order_by(UserAnswerDetail.timestamp.desc())
    # )
    stmt = (
    select(UserAnswerDetail)
    .options(
        selectinload(UserAnswerDetail.quiz_attempt).selectinload(QuizAttempt.user)
    )
    .order_by(UserAnswerDetail.timestamp.desc())
)
    result = await db.execute(stmt)
    all_details: List[UserAnswerDetail] = result.scalars().unique().all()
    
    if not all_details:
        return ""

    # Buat file CSV di memori
    output = io.StringIO()
    # Tentukan header CSV
    headers = [
        "timestamp", "user_id", "user_email", "user_name", "quiz_attempt_id",
        "category_name", "difficulty", "is_correct", "question_text",
        "user_answer", "correct_answer", "options_presented"
    ]
    writer = csv.DictWriter(output, fieldnames=headers)
    writer.writeheader()
    
    # Tulis data baris per baris
    for detail in all_details:
        writer.writerow({
            "timestamp": detail.timestamp.isoformat(),
            "user_id": detail.user_id,
            "user_email": detail.quiz_attempt.user.email if detail.quiz_attempt.user else "N/A",
            "user_name": detail.quiz_attempt.user.name if detail.quiz_attempt.user else "N/A",
            "quiz_attempt_id": detail.quiz_attempt_id,
            "category_name": detail.category_name,
            "difficulty": detail.difficulty,
            "is_correct": detail.is_correct,
            "question_text": detail.question_text,
            "user_answer": detail.user_answer,
            "correct_answer": detail.correct_answer,
            "options_presented": str(detail.options_presented) # Konversi list ke string
        })

    return output.getvalue()
