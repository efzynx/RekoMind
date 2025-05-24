# File: utils/ai_models.py (LOKAL - Memanggil API Colab)
import requests
from typing import List, Dict, Optional
import os
from dotenv import load_dotenv

load_dotenv()

# Ambil URL Ngrok dari environment variable atau hardcode untuk tes
# Pastikan ini adalah BASE URL Ngrok Anda, tanpa path endpoint di sini.
COLAB_NGROK_BASE_URL = os.getenv("COLAB_NGROK_URL", "https://8304-34-83-82-37.ngrok-free.app") 
COLAB_API_ENDPOINT_PATH = "/generate_recommendations_v2" # Path endpoint di Colab

if COLAB_NGROK_BASE_URL == "GANTI_DENGAN_URL_NGROK_COLAB_ANDA":
    print("PERINGATAN LOKAL AI: COLAB_NGROK_URL tidak diset di .env atau kode. Gunakan URL Ngrok yang valid.")

def get_dynamic_content_recommendations(
    query_text_for_embedding: str, 
    search_keyword_for_wikipedia: str, 
    top_n: int = 1 # Sesuaikan default top_n jika perlu
) -> List[Dict]:
    """
    Mengambil rekomendasi dari API yang berjalan di Colab.
    Menerima query untuk embedding dan keyword untuk pencarian Wikipedia.
    """
    if not COLAB_NGROK_BASE_URL or COLAB_NGROK_BASE_URL == "GANTI_DENGAN_URL_NGROK_COLAB_ANDA":
        print("LOKAL AI: URL Ngrok Colab tidak valid. Tidak bisa mengirim request.")
        return [{"title": "Error Konfigurasi AI (Lokal)", "summary": "URL server AI tidak valid.", "url": "#", "source": "System"}]

    full_colab_api_url = f"{COLAB_NGROK_BASE_URL.rstrip('/')}{COLAB_API_ENDPOINT_PATH}"
    
    print(f"LOKAL AI: Mengirim request ke API Colab: {full_colab_api_url}")
    print(f"  LOKAL AI: Payload -> Search Keyword: '{search_keyword_for_wikipedia}', Embedding Context: '{query_text_for_embedding[:70]}...'")
    
    payload = {
        "query_text_for_embedding": query_text_for_embedding,
        "search_keyword_for_wikipedia": search_keyword_for_wikipedia,
        "top_n": top_n
    }
    try:
        response = requests.post(full_colab_api_url, json=payload, timeout=45) 
        response.raise_for_status() # Akan raise HTTPError untuk status 4xx/5xx
        recommendations = response.json()
        print(f"LOKAL AI: Menerima {len(recommendations)} rekomendasi dari Colab.")
        return recommendations
    except requests.exceptions.Timeout:
        print(f"LOKAL AI: Timeout saat menghubungi API Colab di {full_colab_api_url}.")
        return [{"title": "Error Rekomendasi", "summary": "Gagal menghubungi server AI (timeout).", "url": "#", "source": "System"}]
    except requests.exceptions.HTTPError as http_err:
        print(f"LOKAL AI: HTTP error saat menghubungi API Colab di {full_colab_api_url}: {http_err}")
        print(f"LOKAL AI: Response content dari Colab: {response.text}")
        error_summary = f"Server AI mengembalikan error: {response.status_code}."
        try:
            error_detail = response.json().get("error", {}).get("details", response.text)
            error_summary += f" Detail: {error_detail}"
        except:
            error_summary += f" Detail: {response.text}"
        return [{"title": "Error Rekomendasi", "summary": error_summary, "url": "#", "source": "System"}]
    except requests.exceptions.RequestException as e:
        print(f"LOKAL AI: Error request ke API Colab di {full_colab_api_url}: {e}")
        return [{"title": "Error Rekomendasi", "summary": f"Gagal menghubungi server AI: {e}", "url": "#", "source": "System"}]
    except Exception as e:
        print(f"LOKAL AI: Error tidak terduga saat proses rekomendasi via Colab: {e}")
        import traceback
        traceback.print_exc()
        return [{"title": "Error Rekomendasi", "summary": "Terjadi kesalahan internal sistem rekomendasi.", "url": "#", "source": "System"}]

def ensure_ai_model_loaded():
    """Hanya untuk menandakan modul bisa diimpor dan mengecek konfigurasi URL."""
    print("LOKAL AI: Modul pemanggil API Colab siap.")
    if not COLAB_NGROK_BASE_URL or COLAB_NGROK_BASE_URL == "GANTI_DENGAN_URL_NGROK_COLAB_ANDA":
        print("LOKAL AI: PERINGATAN! URL Ngrok untuk Colab belum dikonfigurasi dengan benar di .env atau kode utils/ai_models.py.")
    pass
