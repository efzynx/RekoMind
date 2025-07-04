# File: utils/ai_models.py

import httpx
from typing import List, Dict, Optional
import os
from dotenv import load_dotenv

load_dotenv()

# Ambil URL Ngrok dari environment variable
COLAB_API_BASE_URL = os.getenv("COLAB_API_URL", "https://e7c1-35-227-20-103.ngrok-free.app")
COLAB_API_ENDPOINT_PATH = "/generate_recommendations_v2"

# --- Model 1: Rekomendasi ---

async def get_dynamic_content_recommendations(
    query_text_for_embedding: str,
    search_keyword_for_wikipedia: str,
    top_n: int = 1
) -> List[Dict]:
    payload = {
        "query_text_for_embedding": query_text_for_embedding,
        "search_keyword_for_wikipedia": search_keyword_for_wikipedia,
        "top_n": top_n
    }
    try:
        async with httpx.AsyncClient(timeout=45.0) as client:
            response = await client.post(
                f"{COLAB_API_BASE_URL.rstrip('/')}{COLAB_API_ENDPOINT_PATH}",
                json=payload
            )
            response.raise_for_status()
            return response.json()
    except httpx.HTTPError as e:
        print(f"Error HTTP: {e}")
        return [{"title": "Error", "summary": f"HTTP error: {e}", "url": "#"}]
    except Exception as e:
        print(f"Unknown error: {e}")
        return [{"title": "Error", "summary": f"Unknown error: {e}", "url": "#"}]


# --- Model 2: Analisis Hybrid ---

async def get_holistic_hybrid_analysis_from_colab(performance_data: List[Dict]) -> Dict:
    """
    Mengirim DATA PERFORMA yang sudah diproses dari lokal ke layanan AI di Colab
    untuk mendapatkan analisis hybrid (SVM + LLM).
    """
    if not COLAB_API_BASE_URL:
        return {"error": "URL Layanan AI Colab (COLAB_API_URL) belum di-set."}

    # Endpoint yang benar untuk analisis hybrid di Colab
    endpoint_path = "/holistic_hybrid_analysis"
    full_colab_api_url = f"{COLAB_API_BASE_URL.rstrip('/')}{endpoint_path}"

    # Payload sekarang berisi 'performance_data', bukan 'user_id'
    payload = {"performance_data": performance_data}
    headers = {
    "x-kong-request-id": f"req-{os.urandom(4).hex()}",
    "Authorization": f"Bearer {os.getenv('MISTRAL_API_KEY')}",
    "Content-Type": "application/json"
}


    async with httpx.AsyncClient(timeout=90.0) as client:
        try:
            print(f"LOKAL AI (Model 2): Mengirim data performa ke {full_colab_api_url}")
            response = await client.post(full_colab_api_url, json=payload, headers=headers)
            response.raise_for_status()
            return response.json()
        except httpx.RequestError as e:
            print(f"LOKAL AI (Model 2): Error request ke Colab: {e}")
            return {"error": f"Gagal menghubungi server AI: {e}"}
        except httpx.HTTPStatusError as e:
            print(f"LOKAL AI (Model 2): Colab mengembalikan error: {e.response.status_code} - {e.response.text}")
            return {"error": f"Layanan AI mengembalikan error: {e.response.status_code}"}


def ensure_ai_model_loaded():
    """Memeriksa konfigurasi URL saat startup."""
    print("LOKAL AI: Modul pemanggil API Colab siap.")
    if not COLAB_API_BASE_URL:
        print("LOKAL AI: PERINGATAN! URL Colab belum dikonfigurasi di file .env")

