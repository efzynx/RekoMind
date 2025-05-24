# File: services/recommendation_service.py (LOKAL - PENYEMPURNAAN QUERY V3)

from typing import List, Dict, Optional
import random
import re

try:
    from models.quiz_models import WeaknessAnalysis, IncorrectQuestionDetail
    from models.recommendation_models import Recommendation, RecommendationRequestData
except ImportError as e:
    print(f"Peringatan di recommendation_service: Gagal impor model - {e}")
    WeaknessAnalysis = type("WeaknessAnalysis", (), {}); IncorrectQuestionDetail = type("IncorrectQuestionDetail", (), {}); Recommendation = type("Recommendation", (), {}); RecommendationRequestData = type("RecommendationRequestData", (), {})

try:
    from utils.ai_models import get_dynamic_content_recommendations 
except ImportError as e:
    print(f"PERINGATAN KRUSIAL: Gagal mengimpor 'get_dynamic_content_recommendations' dari utils.ai_models (lokal): {e}")
    def get_dynamic_content_recommendations(query_text_for_embedding: str, search_keyword_for_wikipedia: Optional[str] = None, top_n: int = 3) -> List[Dict]:
        print(f"STUB FALLBACK: get_dynamic_content_recommendations dipanggil karena utils.ai_models (lokal) error.")
        return [{"title": "Error Panggilan AI Lokal", "summary": "Tidak bisa memanggil modul rekomendasi AI.", "url": "#", "source": "System Fallback"}]

def _extract_keywords(text: str, num_keywords: int = 5) -> str:
    """Mengekstrak kata kunci sederhana dari teks."""
    if not text: return ""
    # Hapus karakter non-alfanumerik kecuali spasi, ubah ke huruf kecil
    text = re.sub(r'[^\w\s]', '', text).lower()
    words = text.split()
    # Saring stop words umum (bisa diperluas)
    stop_words = {"di", "ke", "dari", "yang", "ini", "itu", "adalah", "untuk", "dengan", "sebagai", "dalam", "dan", "atau", "jika", "maka", "karena", "sehingga", "tersebut", "pada", "saat", "ketika"}
    keywords = [word for word in words if word not in stop_words and len(word) > 2]
    return " ".join(keywords[:num_keywords])


async def fetch_recommendations_from_quiz_result(
    data: RecommendationRequestData
) -> List[Recommendation]:
    recommendations_output: List[Recommendation] = []
    MAX_TOTAL_RECOMMENDATIONS = 2 
    MAX_RECS_PER_QUERY = 1      
    processed_article_urls = set() 
    
    query_payloads_for_ai: List[Dict[str, str]] = []

    if data.incorrect_questions:
        print(f"Service: Mengambil query dari {len(data.incorrect_questions)} soal salah.")
        shuffled_incorrect_qs = random.sample(data.incorrect_questions, k=min(len(data.incorrect_questions), MAX_TOTAL_RECOMMENDATIONS + 1))
        
        for iq_detail in shuffled_incorrect_qs:
            if len(query_payloads_for_ai) >= MAX_TOTAL_RECOMMENDATIONS * 2 : break # Batasi jumlah query total yang dibuat

            embedding_context = (
                f"Penjelasan konsep untuk pertanyaan: \"{iq_detail.question_text}\". "
                f"Jawaban yang benar adalah \"{iq_detail.correct_answer}\". "
                f"Topik: {iq_detail.category_name}."
            )
            
            # Buat search keyword yang lebih baik: gabungan jawaban benar dan kata kunci pertanyaan
            search_keyword = f"{iq_detail.correct_answer} {_extract_keywords(iq_detail.question_text, 3)} {iq_detail.category_name}"
            search_keyword = " ".join(search_keyword.split()) # Hapus spasi ganda

            query_payloads_for_ai.append({
                "query_text_for_embedding": embedding_context,
                "search_keyword_for_wikipedia": search_keyword,
                "base_title_prefix": f"Materi soal \"{iq_detail.question_text[:20].strip()}...\": "
            })
            
    if data.analysis and len(query_payloads_for_ai) < MAX_TOTAL_RECOMMENDATIONS * 2 : # Cek jika masih ada slot query
        sorted_analysis = sorted(data.analysis, key=lambda x: x.score_percentage)
        for weak_category_analysis in sorted_analysis:
            if len(query_payloads_for_ai) >= MAX_TOTAL_RECOMMENDATIONS * 2: break
            search_keyword = weak_category_analysis.category_name
            embedding_context = f"Informasi umum dan konsep penting dalam kategori {search_keyword}."
            if weak_category_analysis.score_percentage < 75 and weak_category_analysis.total_questions > 0 and \
               search_keyword and not any(qp["search_keyword_for_wikipedia"] == search_keyword for qp in query_payloads_for_ai):
                query_payloads_for_ai.append({
                    "query_text_for_embedding": embedding_context,
                    "search_keyword_for_wikipedia": search_keyword,
                    "base_title_prefix": f"Materi kategori '{search_keyword}': "
                })

    if not query_payloads_for_ai:
        default_search_keyword = random.choice(["Belajar konsep baru", "Fakta sains menarik", "Sejarah penting dunia"])
        query_payloads_for_ai.append({
            "query_text_for_embedding": f"Artikel pengetahuan umum tentang {default_search_keyword}",
            "search_keyword_for_wikipedia": default_search_keyword,
            "base_title_prefix": "Info Umum: "
        })

    for payload_to_ai in query_payloads_for_ai:
        if len(recommendations_output) >= MAX_TOTAL_RECOMMENDATIONS: break
        print(f"Service: Mengirim ke Colab -> Search: '{payload_to_ai['search_keyword_for_wikipedia']}', Embedding Context: '{payload_to_ai['query_text_for_embedding'][:70]}...'")
        
        ai_recs_data = get_dynamic_content_recommendations( 
            query_text_for_embedding=payload_to_ai["query_text_for_embedding"],
            search_keyword_for_wikipedia=payload_to_ai["search_keyword_for_wikipedia"],
            top_n=MAX_RECS_PER_QUERY
        )
        
        for rec_data in ai_recs_data:
            if len(recommendations_output) >= MAX_TOTAL_RECOMMENDATIONS: break
            rec_url = rec_data.get("url")
            summary_text = rec_data.get('summary', '')
            if rec_url and rec_url not in processed_article_urls and summary_text and len(summary_text) > 50 :
                recommendations_output.append(Recommendation(
                    title=f"{payload_to_ai['base_title_prefix']}{rec_data.get('judul', 'Artikel Relevan')}",
                    summary=summary_text, url=rec_url, source=rec_data.get('source', "Wikipedia")
                ))
                processed_article_urls.add(rec_url)

    print(f"Service: Menghasilkan total {len(recommendations_output)} rekomendasi akhir.")
    return recommendations_output
