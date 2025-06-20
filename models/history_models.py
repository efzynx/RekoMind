# File: models/history_models.py

import datetime
import uuid
from typing import List, Optional

from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Text, Boolean # Tambahkan Boolean
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.dialects.postgresql import UUID as PG_UUID, JSONB
from pydantic import BaseModel, ConfigDict

try:
    from .base import Base
except ImportError:
    from models.base import Base

class QuizAttempt(Base):
    __tablename__ = "quiz_attempt"
    id: Mapped[uuid.UUID] = mapped_column(PG_UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("user.id", ondelete="CASCADE"), index=True)
    score: Mapped[float] = mapped_column(Float, nullable=False)
    total_questions: Mapped[int] = mapped_column(Integer, nullable=False)
    correct_answers: Mapped[int] = mapped_column(Integer, nullable=False)
    categories_played: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    timestamp: Mapped[datetime.datetime] = mapped_column(
        DateTime(timezone=True), nullable=False,
        default=lambda: datetime.datetime.now(datetime.timezone.utc)
    )
    user: Mapped["User"] = relationship(back_populates="quiz_attempts")
    
    # Relasi ke detail jawaban
    answer_details: Mapped[List["UserAnswerDetail"]] = relationship(
        "UserAnswerDetail", back_populates="quiz_attempt", cascade="all, delete-orphan"
    )

class QuizAttemptRead(BaseModel):
    id: uuid.UUID
    score: float
    total_questions: int
    correct_answers: int
    categories_played: Optional[str] = None
    timestamp: datetime.datetime
    model_config = ConfigDict(from_attributes=True)

# --- MODEL BARU UNTUK MENYIMPAN SETIAP JAWABAN ---
class UserAnswerDetail(Base):
    __tablename__ = "user_answer_detail"
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    quiz_attempt_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("quiz_attempt.id", ondelete="CASCADE"), index=True)
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("user.id", ondelete="CASCADE"), index=True)
    
    question_text: Mapped[str] = mapped_column(Text)
    options_presented: Mapped[Optional[List[str]]] = mapped_column(JSONB) # Menyimpan semua opsi yg ditampilkan
    user_answer: Mapped[str] = mapped_column(Text)
    correct_answer: Mapped[str] = mapped_column(Text)
    is_correct: Mapped[bool] = mapped_column(Boolean)
    
    category_name: Mapped[Optional[str]] = mapped_column(String(255))
    difficulty: Mapped[Optional[str]] = mapped_column(String(50))
    
    timestamp: Mapped[datetime.datetime] = mapped_column(
        DateTime(timezone=True), nullable=False,
        default=lambda: datetime.datetime.now(datetime.timezone.utc)
    )
    
    quiz_attempt: Mapped["QuizAttempt"] = relationship(back_populates="answer_details")
