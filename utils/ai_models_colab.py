# !pip install sentence-transformers wikipedia Flask pyngrok numpy

# File: colab_ai_server.py (atau nama file Python Anda di Google Colab)
# Berisi logika AI yang diekspos sebagai API Flask via Ngrok

from flask import Flask, request, jsonify
from pyngrok import ngrok, conf
import threading
import time
import html
import urllib.parse
import re
import os

from sentence_transformers import SentenceTransformer, util
import numpy as np
import wikipedia
from typing import List, Dict, Optional

# --- Konfigurasi ---
MODEL_NAME = 'paraphrase-multilingual-MiniLM-L12-v2'
WIKIPEDIA_LANG = "id"
NUM_SENTENCES_FOR_SUMMARY = 10 # Ambil lebih banyak kalimat untuk ringkasan awal
NUM_ARTICLES_TO_FETCH_PER_QUERY = 3 # Jumlah artikel yang dicari di Wikipedia per query
MIN_CONTENT_LENGTH_FOR_VALID_ARTICLE = 250 # Naikkan agar ringkasan lebih berarti
SIMILARITY_THRESHOLD = 0.4 # Threshold minimal kemiripan yang Anda minta

_sentence_model: Optional[SentenceTransformer] = None

def _load_sentence_model_once_colab():
    global _sentence_model
    if _sentence_model is None:
        try:
            print(f"COLAB AI: Memuat model Sentence Transformer: '{MODEL_NAME}'...")
            _sentence_model = SentenceTransformer(MODEL_NAME)
            print(f"COLAB AI: Model Sentence Transformer '{MODEL_NAME}' berhasil dimuat.")
        except Exception as e:
            print(f"COLAB AI: GAGAL memuat model Sentence Transformer '{MODEL_NAME}': {e}")
            _sentence_model = None
    return _sentence_model

def _decode_and_clean_text_colab(text: str) -> str:
    if not text: return ""
    try:
        decoded_text = text
        for _ in range(2):
            decoded_text = urllib.parse.unquote(decoded_text)
            decoded_text = html.unescape(decoded_text)
        decoded_text = re.sub(r'\[\d+(?:,\s*\d+)*\]', '', decoded_text)
        decoded_text = re.sub(r'\[\w+\sneeded\]', '', decoded_text, flags=re.IGNORECASE)
        decoded_text = re.sub(r'\{\{.*?\}\}', '', decoded_text, flags=re.DOTALL)
        decoded_text = re.sub(r'', '', decoded_text, flags=re.DOTALL)
        decoded_text = re.sub(r'<[^>]+>', '', decoded_text)
        decoded_text = re.sub(r'\s\s+', ' ', decoded_text)
        decoded_text = re.sub(r'\n\s*\n', '\n', decoded_text)
        return decoded_text.strip()
    except Exception as e:
        print(f"COLAB AI Warning: Error decoding/cleaning text '{text[:70]}...': {e}")
        return text.strip()

def _fetch_wikipedia_articles_for_search_keyword_colab(
    search_keyword: str,
    num_articles_to_fetch: int
) -> List[Dict]:
    print(f"  COLAB AI: Mencari artikel Wikipedia untuk keyword: '{search_keyword}'")
    wikipedia.set_lang(WIKIPEDIA_LANG)
    articles_info = []

    try:
        # Coba cari dengan keyword yang lebih spesifik dulu
        search_results = wikipedia.search(search_keyword, results=num_articles_to_fetch)
        if not search_results and len(search_keyword.split()) > 2: # Jika gagal dan keyword panjang, coba persingkat
            shorter_keyword = " ".join(search_keyword.split()[:2]) # Ambil 2 kata pertama
            print(f"    COLAB AI: Pencarian awal untuk '{search_keyword}' kosong, mencoba dengan '{shorter_keyword}'...")
            search_results = wikipedia.search(shorter_keyword, results=num_articles_to_fetch)

        if not search_results:
            print(f"    COLAB AI: Tidak ada hasil pencarian Wikipedia untuk '{search_keyword}' (atau variasinya).")
            return []

        print(f"    COLAB AI: Hasil pencarian mentah: {search_results}")
        fetched_count = 0
        processed_titles = set()

        for topic_title in search_results:
            if fetched_count >= num_articles_to_fetch: break
            if topic_title in processed_titles: continue

            try:
                page = wikipedia.page(topic_title, auto_suggest=True, redirect=True)
                content_to_use = ""
                title_decoded = _decode_and_clean_text_colab(page.title)

                try: # Coba ambil summary
                    summary = wikipedia.summary(page.title, sentences=NUM_SENTENCES_FOR_SUMMARY, auto_suggest=False, chars=0)
                    summary_decoded = _decode_and_clean_text_colab(summary)
                    if summary_decoded and len(summary_decoded) >= MIN_CONTENT_LENGTH_FOR_VALID_ARTICLE:
                        content_to_use = summary_decoded
                except Exception: pass

                if not content_to_use: # Jika summary gagal/pendek, coba konten utama
                    raw_page_content = _decode_and_clean_text_colab(page.content)
                    paragraphs = [p for p in raw_page_content.split('\n') if p.strip() and len(p.split()) > 10]
                    buffer = []
                    current_length = 0
                    for p_text in paragraphs[:5]:
                        buffer.append(p_text)
                        current_length += len(p_text)
                        if current_length > 2000 : break
                    content_to_use = " ".join(buffer)
                    if not content_to_use or len(content_to_use) < MIN_CONTENT_LENGTH_FOR_VALID_ARTICLE:
                         content_to_use = raw_page_content[:2500].strip() + "..." if raw_page_content else ""

                if content_to_use and len(content_to_use) >= MIN_CONTENT_LENGTH_FOR_VALID_ARTICLE:
                    articles_info.append({
                        "judul": title_decoded, "konten": content_to_use,
                        "url": page.url, "source": "Wikipedia (Colab Dinamis)"
                    })
                    print(f"    -> Colab: Artikel '{title_decoded}' diproses (konten: {len(content_to_use)} chars).")
                    fetched_count += 1; processed_titles.add(title_decoded)
                else:
                    print(f"    AI Colab Peringatan: Konten untuk '{title_decoded}' tidak memenuhi syarat (panjang: {len(content_to_use)}).")
            except Exception as e_page_fetch: print(f"    Colab Error saat mengambil/memproses halaman '{topic_title}': {e_page_fetch}")
    except Exception as e_search: print(f"  Colab Error saat wikipedia.search('{search_keyword}'): {e_search}")
    return articles_info

def get_dynamic_content_recommendations_colab(
    query_text_for_embedding: str,
    search_keyword_for_wikipedia: str,
    top_n_final_recommendations: int = 1
) -> List[Dict]:
    global _sentence_model
    if _sentence_model is None: _load_sentence_model_once_colab();
    if _sentence_model is None: return [{"title": "Model AI Colab Belum Siap", "summary": "Coba lagi.", "url": "#", "source": "Colab System"}]

    print(f"\nCOLAB AI: Memproses. Embedding Query: '{query_text_for_embedding[:70]}...', Wiki Search: '{search_keyword_for_wikipedia}'")

    dynamic_corpus_articles = _fetch_wikipedia_articles_for_search_keyword_colab(
        search_keyword_for_wikipedia,
        NUM_ARTICLES_TO_FETCH_PER_QUERY
    )

    if not dynamic_corpus_articles: print(f"  COLAB AI: Tidak ada artikel dari Wikipedia untuk keyword '{search_keyword_for_wikipedia}'."); return []

    print(f"  COLAB AI: {len(dynamic_corpus_articles)} artikel dinamis ditemukan. Membuat embeddings...")
    dynamic_corpus_contents = [article['konten'] for article in dynamic_corpus_articles]
    try:
        dynamic_corpus_embeddings = _sentence_model.encode(dynamic_corpus_contents, convert_to_tensor=False)
        query_embedding = _sentence_model.encode([query_text_for_embedding], convert_to_tensor=False)[0]
        cosine_scores = util.cos_sim(query_embedding, dynamic_corpus_embeddings)[0].numpy()

        scored_articles = [{"score": cosine_scores[i], **article_info} for i, article_info in enumerate(dynamic_corpus_articles)]
        scored_articles.sort(key=lambda x: x["score"], reverse=True)

    except Exception as e_embed: print(f"  COLAB AI: ERROR saat encoding/similarity: {e_embed}"); return [{"title": "Error Proses AI Colab", "summary": str(e_embed), "url": "#", "source": "Colab System"}]

    recommendations = []
    print(f"  COLAB AI: Kandidat Rekomendasi (diurutkan, threshold={SIMILARITY_THRESHOLD}):")
    for i, article_candidate in enumerate(scored_articles):
        print(f"    Kandidat {i+1}: Judul: {article_candidate['judul']} (Skor: {article_candidate['score']:.4f}) (Konten: {len(article_candidate['konten'])} char)")

        if article_candidate['score'] >= SIMILARITY_THRESHOLD: # Terapkan threshold
            recommendations.append({
                "judul": article_candidate['judul'],
                "summary": article_candidate['konten'][:450] + "..." if len(article_candidate['konten']) > 450 else article_candidate['konten'],
                "url": article_candidate['url'],
                "source": article_candidate['source'],
            })
            if len(recommendations) >= top_n_final_recommendations: break # Ambil top_n SETELAH threshold

    if not recommendations: print(f"    COLAB AI: Tidak ada rekomendasi yang memenuhi threshold {SIMILARITY_THRESHOLD}.")
    return recommendations

# --- Flask App (Sama seperti #161, endpoint /generate_recommendations_v2) ---
app = Flask(__name__)
_load_sentence_model_once_colab()

COLAB_API_ENDPOINT_PATH = "/generate_recommendations_v2"

@app.route(COLAB_API_ENDPOINT_PATH, methods=["POST"])
def generate_recommendations_endpoint_v2():
    try:
        data = request.get_json()
        print(f"COLAB API: Menerima data: {data}")
        if not data or "query_text_for_embedding" not in data or "search_keyword_for_wikipedia" not in data:
            return jsonify({"error": "query_text_for_embedding dan search_keyword_for_wikipedia wajib"}), 400

        query_embed = data["query_text_for_embedding"]
        search_wiki = data["search_keyword_for_wikipedia"]
        top_n = data.get("top_n", 1)

        recommendations = get_dynamic_content_recommendations_colab(query_embed, search_wiki, top_n)
        print(f"COLAB API: Mengembalikan {len(recommendations)} rekomendasi.")
        return jsonify(recommendations)
    except Exception as e:
        print(f"COLAB API: Error di endpoint: {e}"); import traceback; traceback.print_exc()
        return jsonify({"error": "Internal server error di Colab", "details": str(e)}), 500

# --- Ngrok Setup (Sama seperti #161) ---
NGROK_AUTH_TOKEN = os.environ.get("NGROK_AUTH_TOKEN", "1wIKVgVrfDvzbOpqvTYd84P3qTo_649KyUcCJXPYtKcBbygkh")
if NGROK_AUTH_TOKEN == "1wIKVgVrfDvzbOpqvTYd84P3qTo_649KyUcCJXPYtKcBbygkh": print("!!! PERINGATAN: NGROK_AUTH_TOKEN tidak diset !!!")
conf.get_default().auth_token = NGROK_AUTH_TOKEN; conf.get_default().monitor_thread = False
public_url_global = None
def run_flask_app(): app.run(host="0.0.0.0", port=5000, debug=False)
if __name__ == '__main__':
    _load_sentence_model_once_colab()
    if not _sentence_model: print("COLAB: GAGAL MEMUAT MODEL AI.")
    else: print("COLAB: Model AI siap.")
    flask_thread = threading.Thread(target=run_flask_app); flask_thread.daemon = True; flask_thread.start(); time.sleep(3)
    try:
        active_tunnels = ngrok.get_tunnels();
        for tunnel in active_tunnels: print(f"  COLAB: Menutup tunnel Ngrok lama: {tunnel.public_url}"); ngrok.disconnect(tunnel.public_url)
        ngrok.kill(); time.sleep(1)
        public_url_global = ngrok.connect(5000, "http", bind_tls=True)
        print("-" * 50); print(f" * Ngrok Tunnel (HTTPS) Aktif di: {public_url_global}"); print(f" * Endpoint rekomendasi V2: {public_url_global}{COLAB_API_ENDPOINT_PATH}"); print(" * API Rekomendasi di Colab SIAP DIAKSES."); print("-" * 50)
    except Exception as e_ngrok: print(f"Error memulai Ngrok: {e_ngrok}")
    try:
        while True: time.sleep(3600); print(f"Ngrok tunnel masih aktif di: {public_url_global}" if public_url_global else "Mencoba memeriksa status Ngrok...")
    except KeyboardInterrupt: print("COLAB: Proses dihentikan.")
    finally:
        print("COLAB: Menutup tunnel Ngrok...");
        if public_url_global:
            try: ngrok.disconnect(public_url_global)
            except Exception as e: print(f"Error disconnect ngrok: {e}")
        try: ngrok.kill()
        except Exception as e: print(f"Error kill ngrok: {e}")
        print("COLAB: Selesai.")
