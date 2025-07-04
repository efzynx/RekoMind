# File: services/analysis_service.py

import random
from typing import List, Dict
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, case
import uuid

# Import fungsi BARU dari ai_models.py yang sudah di-upgrade
from utils.ai_models import get_holistic_hybrid_analysis_from_colab

# Import model DB Anda (pastikan path-nya benar)
from models.history_models import UserAnswerDetail
from models.analysis_models import DeepAnalysisResult, WeaknessConcept

async def perform_deep_analysis_for_user(user_id: uuid.UUID, db: AsyncSession) -> DeepAnalysisResult:
    """
    Service ini mengambil data dari DB LOKAL, memprosesnya,
    lalu mengirim data matang ke Colab untuk analisis hybrid.
    """
    print(f"SERVICE LOKAL: Memulai analisis holistik untuk user_id: {user_id}")
    
    # Langkah 1: Query ke database LOKAL untuk mendapatkan riwayat jawaban.
    # Ini adalah langkah kunci untuk memastikan data pengguna baru bisa dianalisis.
    stmt = select(UserAnswerDetail).where(UserAnswerDetail.user_id == user_id)
    result = await db.execute(stmt)
    all_answers: List[UserAnswerDetail] = result.scalars().unique().all()

    if not all_answers or len(all_answers) < 5:
        return DeepAnalysisResult(
            user_id=str(user_id),
            summary_text="Belum ada cukup riwayat jawaban untuk dianalisis. Selesaikan lebih banyak kuis untuk mendapatkan analisis mendalam!",
            weakest_concepts=[],
            example_incorrect_questions=[]
        )

    # Langkah 2: Lakukan proses statistik di LOKAL.
    # Ubah data mentah dari database menjadi `performance_list` yang siap dikirim.
    stats_by_category: Dict[str, Dict] = {}
    incorrect_questions_texts: List[str] = []
    
    for answer in all_answers:
        cat = answer.category_name or "Tanpa Kategori"
        if cat not in stats_by_category:
            stats_by_category[cat] = {"correct": 0, "total": 0}
        stats_by_category[cat]["total"] += 1
        if answer.is_correct:
            stats_by_category[cat]["correct"] += 1
        elif answer.question_text:
             incorrect_questions_texts.append(answer.question_text)

    performance_list = []
    weakness_concepts = []

    for category, stats in stats_by_category.items():
        if stats["total"] > 0:
            accuracy = stats["correct"] / stats["total"]

            # Ambil max 1-2 soal salah di kategori ini
            sample_wrong = [
                {
                    "question_text": ans.question_text,
                    "user_answer": ans.user_answer,
                    "correct_answer": ans.correct_answer
                }
                for ans in all_answers
                if ans.category_name == category and not ans.is_correct and ans.question_text
            ][:2]  # ambil max 2 contoh

            performance_list.append({
                "category_name": category,
                "accuracy": round(accuracy, 2),
                "total_questions": stats["total"],
                "example_incorrect_questions": sample_wrong  # ✅ Tambahan field baru
            })

            if accuracy < 0.6 and stats["total"] > 2:
                weakness_concepts.append(WeaknessConcept(
                    topic=category,
                    error_rate=round((1 - accuracy) * 100, 2),
                    total_questions_in_topic=stats["total"],
                    incorrect_answers_in_topic=stats["total"] - stats["correct"]
                ))


    # Langkah 3: Panggil layanan Colab dengan DATA yang sudah matang.
    analysis_result = await get_holistic_hybrid_analysis_from_colab(performance_list)

    # Ambil langsung key yang dikirim dari Colab
    holistic_summary = analysis_result.get("holistic_analysis", "Gagal mendapatkan ringkasan dari layanan AI.")


    # # Ambil isi dari chat completion
    # try:
    #     holistic_summary = analysis_result["choices"][0]["message"]["content"]
    # except Exception as e:
    #     print("ERROR parsing respons dari Colab:", e)
    #     holistic_summary = "Gagal mendapatkan ringkasan dari layanan AI."

    
    weakness_concepts.sort(key=lambda x: x.error_rate, reverse=True)
    example_questions = random.sample(incorrect_questions_texts, k=min(len(incorrect_questions_texts), 3))

    # Langkah 4: Kembalikan hasil gabungan (data statistik lokal + ringkasan dari AI)
    return DeepAnalysisResult(
        user_id=str(user_id),
        # summary_text=holistic_summary,
        summary_text=holistic_summary,
        weakest_concepts=weakness_concepts[:3],
        example_incorrect_questions=example_questions
    )
