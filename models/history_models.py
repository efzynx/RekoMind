# File: models/history_models.py

import datetime
import uuid
from typing import List, Optional

from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.dialects.postgresql import UUID as PG_UUID
from pydantic import BaseModel, ConfigDict

try:
    from .base import Base
    # from .user_models import User # Tidak perlu impor User jika hanya untuk type hint string
except ImportError:
    from models.base import Base
    # from models.user_models import User

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
    # Relasi balik ke User
    user: Mapped["User"] = relationship(back_populates="quiz_attempts") # Gunakan string "User"

class QuizAttemptRead(BaseModel):
    id: uuid.UUID
    score: float
    total_questions: int
    correct_answers: int
    categories_played: Optional[str] = None
    timestamp: datetime.datetime
    model_config = ConfigDict(from_attributes=True)