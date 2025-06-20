# File: models/analysis_models.py (File BARU)

from pydantic import BaseModel
from typing import List, Optional

class WeaknessConcept(BaseModel):
    """Mewakili satu konsep atau kategori kelemahan."""
    topic: str
    error_rate: float # Persentase kesalahan (misal, 0.75 untuk 75%)
    total_questions_in_topic: int
    incorrect_answers_in_topic: int

class DeepAnalysisResult(BaseModel):
    """Skema untuk hasil analisis mendalam yang dikembalikan ke frontend."""
    user_id: str
    summary_text: str # Ringkasan teks, misal "Analisis menunjukkan Anda kuat di Sejarah tapi perlu perbaikan di Sains."
    weakest_concepts: List[WeaknessConcept] # Daftar konsep terlemah
    example_incorrect_questions: List[str] # Beberapa contoh teks pertanyaan yang sering salah
