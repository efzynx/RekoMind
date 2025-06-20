# File: services/analysis_service.py (File BARU)

from typing import List, Dict
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
import uuid
import random

# Impor model yang relevan
try:
    from models.history_models import UserAnswerDetail, QuizAttempt
    from models.analysis_models import DeepAnalysisResult, WeaknessConcept
except ImportError:
    # Fallback untuk pengembangan
    UserAnswerDetail = type("UserAnswerDetail", (), {})
    DeepAnalysisResult = type("DeepAnalysisResult", (), {})
    WeaknessConcept = type("WeaknessConcept", (), {})

async def perform_deep_analysis_for_user(user_id: uuid.UUID, db: AsyncSession) -> DeepAnalysisResult:
    """
    Melakukan analisis statistik mendalam pada seluruh riwayat jawaban seorang pengguna.
    """
    print(f"ANALYSIS SERVICE: Memulai analisis mendalam untuk user_id: {user_id}")
    
    # 1. Ambil semua detail jawaban untuk pengguna ini
    stmt = select(UserAnswerDetail).where(UserAnswerDetail.user_id == user_id)
    result = await db.execute(stmt)
    all_answers: List[UserAnswerDetail] = result.scalars().all()

    if not all_answers:
        return DeepAnalysisResult(
            user_id=str(user_id),
            summary_text="Belum ada cukup riwayat jawaban untuk dianalisis. Selesaikan lebih banyak kuis!",
            weakest_concepts=[],
            example_incorrect_questions=[]
        )

    # 2. Lakukan analisis statistik: hitung kesalahan per kategori
    stats_by_category: Dict[str, Dict[str, int]] = {}
    incorrect_questions_texts: List[str] = []

    for answer in all_answers:
        cat = answer.category_name or "Tanpa Kategori"
        if cat not in stats_by_category:
            stats_by_category[cat] = {"correct": 0, "incorrect": 0, "total": 0}
        
        stats_by_category[cat]["total"] += 1
        if answer.is_correct:
            stats_by_category[cat]["correct"] += 1
        else:
            stats_by_category[cat]["incorrect"] += 1
            incorrect_questions_texts.append(answer.question_text)

    # 3. Hitung persentase kesalahan dan identifikasi kelemahan
    weakness_concepts: List[WeaknessConcept] = []
    for category, stats in stats_by_category.items():
        total = stats["total"]
        incorrect = stats["incorrect"]
        if total > 0:
            error_rate = incorrect / total
            # Anggap topik sebagai kelemahan jika error rate > 40% dan sudah menjawab > 2 soal
            if error_rate > 0.4 and total > 2:
                weakness_concepts.append(
                    WeaknessConcept(
                        topic=category,
                        error_rate=round(error_rate * 100, 2), # Dalam persen
                        total_questions_in_topic=total,
                        incorrect_answers_in_topic=incorrect
                    )
                )

    # Urutkan kelemahan dari yang paling parah
    weakness_concepts.sort(key=lambda x: x.error_rate, reverse=True)
    
    # 4. Buat ringkasan teks
    summary = f"Total {len(all_answers)} soal telah dijawab. "
    if not weakness_concepts:
        summary += "Secara umum, pemahaman Anda sudah sangat baik di semua topik yang diujikan!"
    else:
        top_weakness = weakness_concepts[0].topic
        summary += f"Analisis menunjukkan area yang paling perlu diperkuat adalah pada topik: '{top_weakness}'."

    # Ambil beberapa contoh soal yang salah secara acak
    example_questions = random.sample(incorrect_questions_texts, k=min(len(incorrect_questions_texts), 3))

    return DeepAnalysisResult(
        user_id=str(user_id),
        summary_text=summary,
        weakest_concepts=weakness_concepts[:3], # Ambil top 3 kelemahan
        example_incorrect_questions=example_questions
    )
