# File: utils/llm_client.py (File BARU)

import os
import json
from mistralai.async_client import MistralAsyncClient # <-- Gunakan Async Client
from typing import List, Dict

async def get_holistic_analysis_from_mistral(performance_list: List[Dict]) -> str:
    """
    Menghasilkan analisis holistik dengan memanggil Mistral AI API secara asynchronous.
    """
    try:
        # Ambil API Key dari environment variables
        api_key = os.environ.get("MISTRAL_API_KEY")
        if not api_key:
            raise ValueError("MISTRAL_API_KEY tidak diset di environment variables.")

        # Inisialisasi Klien Async
        client = MistralAsyncClient(api_key=api_key)
        model = "mistral-small-latest"

        # Buat prompt yang komprehensif untuk LLM
        prompt = f"""
        Anda adalah "Reko", seorang analis belajar AI dari Rekomind. Tugas Anda adalah menganalisis profil belajar seorang pengguna secara KESELURUHAN berdasarkan riwayat kuis mereka, lalu memberikan satu ringkasan yang koheren dalam Bahasa Indonesia.

        Berikut adalah data performa lengkap pengguna di semua kategori yang pernah diikuti:
        ```json
        {json.dumps(performance_list, indent=2)}
        ```

        Instruksi untuk Anda:
        1.  **Analisis Keseluruhan:** Lihat semua data di atas. Identifikasi 1-2 kategori di mana pengguna memiliki akurasi **tertinggi** (kekuatan utama) dan 1-2 kategori di mana akurasinya **terendah** (area untuk pengembangan).
        2.  **Buat Ringkasan Pembuka:** Mulai dengan memberikan ringkasan umum. Puji kekuatan utama pengguna terlebih dahulu.
        3.  **Bahas Area Pengembangan:** Lanjutkan dengan menyebutkan area yang bisa ditingkatkan dengan cara yang positif.
        4.  **Tabel Ringkasan (Wajib):** Buat tabel Markdown sederhana yang merangkum performa di semua kategori untuk visualisasi yang mudah.
        5.  **Penutup Motivasi:** Akhiri dengan kalimat yang memotivasi pengguna untuk terus belajar.
        """

        # Panggil API secara 'await'
        chat_response = await client.chat(
            model=model,
            messages=[{"role": "user", "content": prompt}],
        )

        return chat_response.choices[0].message.content

    except Exception as e:
        print(f"FATAL: Error saat menghubungi Mistral AI: {e}")
        # Kembalikan pesan error yang ramah untuk ditampilkan di UI
        return "Maaf, terjadi kesalahan saat mencoba membuat analisis dari AI. Tim kami sedang menanganinya."