# File: models/user_models.py

from fastapi import Depends, HTTPException
from fastapi_users.db import SQLAlchemyBaseUserTableUUID, SQLAlchemyUserDatabase
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase, relationship, Mapped, mapped_column
from sqlalchemy import String, Boolean, Text
from typing import List, Optional, AsyncGenerator # Pastikan AsyncGenerator ada
import uuid
import os
from dotenv import load_dotenv

# Impor Base dari file base.py
try:
    from .base import Base
except ImportError:
    from models.base import Base # Fallback

# Impor QuizAttempt pakai string untuk type hint di relasi
# Impor ini tidak wajib di sini jika hanya untuk type hint string "QuizAttempt"
# try: from .history_models import QuizAttempt
# except ImportError: from models.history_models import QuizAttempt

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise ValueError("FATAL ERROR: DATABASE_URL environment variable is not set!")

# Variabel global untuk engine & session maker
_engine = None
_async_session_maker = None

def get_engine():
    global _engine
    if _engine is None:
        if not DATABASE_URL:
            raise RuntimeError("DATABASE_URL environment variable not set!")
        print(f"Creating async engine for URL: ...@{DATABASE_URL.split('@')[-1] if '@' in DATABASE_URL else DATABASE_URL}")
        try:
            _engine = create_async_engine(DATABASE_URL)
        except Exception as e:
             print(f"!!! FAILED TO CREATE ASYNC ENGINE: {e}")
             raise RuntimeError(f"Failed to create DB engine: {e}") from e
    return _engine

def get_session_maker():
    global _async_session_maker
    if _async_session_maker is None:
        engine = get_engine()
        _async_session_maker = async_sessionmaker(
            engine, class_=AsyncSession, expire_on_commit=False
        )
        print("Session maker created.")
    return _async_session_maker

class User(SQLAlchemyBaseUserTableUUID, Base):
    """Model Database untuk User dengan field profil tambahan."""
    __tablename__ = "user"

    # --- KOLOM PROFIL BARU ---
    name: Mapped[Optional[str]] = mapped_column(String(150), nullable=True)
    education_level: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    institution_name: Mapped[Optional[str]] = mapped_column(String(200), nullable=True)
    favorite_subjects: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    # --------------------------

    quiz_attempts: Mapped[List["QuizAttempt"]] = relationship(
        "QuizAttempt", # Gunakan string jika QuizAttempt didefinisi di file lain
        back_populates="user",
        cascade="all, delete-orphan",
        lazy="selectin"
    )

async def get_async_session() -> AsyncGenerator[AsyncSession, None]:
    session_maker = get_session_maker()
    async with session_maker() as session:
        yield session

async def get_user_db(session: AsyncSession = Depends(get_async_session)):
    yield SQLAlchemyUserDatabase(session, User)

# --- Skema Pydantic User ---
from fastapi_users import schemas
from pydantic import ConfigDict, EmailStr, Field # <-- PASTIKAN 'Field' DIIMPOR DI SINI

class UserRead(schemas.BaseUser[uuid.UUID]):
    name: Optional[str] = None
    education_level: Optional[str] = None
    institution_name: Optional[str] = None
    favorite_subjects: Optional[str] = None
    model_config = ConfigDict(from_attributes=True)

class UserCreate(schemas.BaseUserCreate):
    email: EmailStr
    password: str
    name: str = Field(..., min_length=1, max_length=150)
    education_level: str = Field(..., min_length=2, max_length=50)
    institution_name: Optional[str] = Field(None, max_length=200)
    favorite_subjects: Optional[str] = Field(None)

class UserUpdate(schemas.BaseUserUpdate):
    name: Optional[str] = Field(None, min_length=1, max_length=150)
    education_level: Optional[str] = Field(None, min_length=2, max_length=50)
    institution_name: Optional[str] = Field(None, max_length=200)
    favorite_subjects: Optional[str] = Field(None)