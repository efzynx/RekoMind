# File: models/quiz_models.py

from typing import List, Dict, Optional
from pydantic import BaseModel, Field

class CategoryInfo(BaseModel):
    id: int
    name: str

class QuestionOut(BaseModel):
    id: str
    category_name: str
    difficulty: str
    question: str
    options: List[str]

class AnswerIn(BaseModel):
    question_id: str
    user_answer: str

class QuizSubmission(BaseModel):
    answers: List[AnswerIn]

class WeaknessAnalysis(BaseModel):
    category_name: str
    score_percentage: float
    correct_count: int
    total_questions: int

class IncorrectQuestionDetail(BaseModel): # Skema untuk detail soal salah
    question_id: str
    question_text: str
    user_answer: str
    correct_answer: str
    category_name: str
    difficulty: str

class QuizResult(BaseModel): # Skema hasil kuis
    total_questions: int
    correct_answers_count: int
    score_percentage: float
    analysis: List[WeaknessAnalysis]
    incorrect_questions: List[IncorrectQuestionDetail] # <-- FIELD BARU DI SINI

class QuizStartResponse(BaseModel): # Skema respons saat mulai kuis
    session_id: str
    questions: List[QuestionOut]