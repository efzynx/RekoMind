# File: services/recommendation_service.py (LOKAL - PENYEMPURNAAN QUERY V3)
from typing import List, Dict, Optional
import random
import re
import asyncio

try:
    from models.quiz_models import WeaknessAnalysis, IncorrectQuestionDetail
    from models.recommendation_models import Recommendation, RecommendationRequestData
except ImportError as e:
    print(f"Peringatan di recommendation_service: Gagal impor model - {e}")
    WeaknessAnalysis = type("WeaknessAnalysis", (), {})
    IncorrectQuestionDetail = type("IncorrectQuestionDetail", (), {})
    Recommendation = type("Recommendation", (), {})
    RecommendationRequestData = type("RecommendationRequestData", (), {})

try:
    from utils.ai_models import get_dynamic_content_recommendations
except ImportError as e:
    print(f"PERINGATAN KRUSIAL: Gagal mengimpor 'get_dynamic_content_recommendations' dari utils.ai_models (lokal): {e}")

    async def get_dynamic_content_recommendations(query_text_for_embedding: str, search_keyword_for_wikipedia: Optional[str] = None, top_n: int = 3) -> List[Dict]:
        print("STUB FALLBACK: get_dynamic_content_recommendations dipanggil karena utils.ai_models error.")
        return [{"title": "Error Panggilan AI Lokal", "summary": "Tidak bisa memanggil modul rekomendasi AI.", "url": "#", "source": "System Fallback"}]

def _extract_keywords(text: str, num_keywords: int = 5) -> str:
    if not text: return ""
    text = re.sub(r'[^\w\s]', '', text).lower()
    words = text.split()
    stop_words = {"di", "ke", "dari", "yang", "ini", "itu", "adalah", "untuk", "dengan", "sebagai", "dalam", "dan", "atau", "jika", "maka", "karena", "sehingga", "tersebut", "pada", "saat", "ketika"}
    keywords = [word for word in words if word not in stop_words and len(word) > 2]
    return " ".join(keywords[:num_keywords])

async def fetch_recommendations_from_quiz_result(data: RecommendationRequestData) -> List[Recommendation]:
    recommendations_output: List[Recommendation] = []
    MAX_TOTAL_RECOMMENDATIONS = 2
    MAX_RECS_PER_QUERY = 1
    processed_article_urls = set()
    query_payloads_for_ai: List[Dict[str, str]] = []

    if data.incorrect_questions:
        print(f"Service: Mengambil query dari {len(data.incorrect_questions)} soal salah.")
        shuffled = random.sample(data.incorrect_questions, k=min(len(data.incorrect_questions), MAX_TOTAL_RECOMMENDATIONS + 1))

        for iq in shuffled:
            if len(query_payloads_for_ai) >= MAX_TOTAL_RECOMMENDATIONS * 2: break
            embedding_context = (
                f"Penjelasan konsep untuk pertanyaan: \"{iq.question_text}\". "
                f"Jawaban yang benar adalah \"{iq.correct_answer}\". "
                f"Topik: {iq.category_name}."
            )
            search_keyword = f"{iq.correct_answer} {_extract_keywords(iq.question_text, 3)} {iq.category_name}".strip()
            query_payloads_for_ai.append({
                "query_text_for_embedding": embedding_context,
                "search_keyword_for_wikipedia": search_keyword,
                "base_title_prefix": f"Materi soal \"{iq.question_text[:20].strip()}...\": "
            })

    if data.analysis and len(query_payloads_for_ai) < MAX_TOTAL_RECOMMENDATIONS * 2:
        sorted_analysis = sorted(data.analysis, key=lambda x: x.score_percentage)
        for wa in sorted_analysis:
            if len(query_payloads_for_ai) >= MAX_TOTAL_RECOMMENDATIONS * 2: break
            if wa.score_percentage < 75 and wa.total_questions > 0 and wa.category_name:
                if not any(q["search_keyword_for_wikipedia"] == wa.category_name for q in query_payloads_for_ai):
                    query_payloads_for_ai.append({
                        "query_text_for_embedding": f"Informasi umum dan konsep penting dalam kategori {wa.category_name}.",
                        "search_keyword_for_wikipedia": wa.category_name,
                        "base_title_prefix": f"Materi kategori '{wa.category_name}': "
                    })

    if not query_payloads_for_ai:
        default_kw = random.choice(["Belajar konsep baru", "Fakta sains menarik", "Sejarah penting dunia"])
        query_payloads_for_ai.append({
            "query_text_for_embedding": f"Artikel pengetahuan umum tentang {default_kw}",
            "search_keyword_for_wikipedia": default_kw,
            "base_title_prefix": "Info Umum: "
        })

    for payload in query_payloads_for_ai:
        if len(recommendations_output) >= MAX_TOTAL_RECOMMENDATIONS: break

        print(f"Service: Mengirim ke Colab -> Search: '{payload['search_keyword_for_wikipedia']}', Embedding Context: '{payload['query_text_for_embedding'][:70]}...'")

        try:
            if asyncio.iscoroutinefunction(get_dynamic_content_recommendations):
                ai_recs_data = await get_dynamic_content_recommendations(
                    query_text_for_embedding=payload["query_text_for_embedding"],
                    search_keyword_for_wikipedia=payload["search_keyword_for_wikipedia"],
                    top_n=MAX_RECS_PER_QUERY
                )
            else:
                ai_recs_data = get_dynamic_content_recommendations(
                    query_text_for_embedding=payload["query_text_for_embedding"],
                    search_keyword_for_wikipedia=payload["search_keyword_for_wikipedia"],
                    top_n=MAX_RECS_PER_QUERY
                )
        except Exception as e:
            print(f"Service: Error saat mengambil rekomendasi: {e}")
            continue

        for rec in ai_recs_data:
            if len(recommendations_output) >= MAX_TOTAL_RECOMMENDATIONS: break
            if rec.get("url") and rec["url"] not in processed_article_urls:
                if rec.get("summary") and len(rec["summary"]) > 50:
                    recommendations_output.append(Recommendation(
                        title=f"{payload['base_title_prefix']}{rec.get('judul', 'Artikel Relevan')}",
                        summary=rec["summary"],
                        url=rec["url"],
                        source=rec.get("source", "Wikipedia")
                    ))
                    processed_article_urls.add(rec["url"])

    print(f"Service: Menghasilkan total {len(recommendations_output)} rekomendasi akhir.")
    return recommendations_output
