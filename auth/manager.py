# File: auth/manager.py

import uuid
import os
from typing import Optional

from fastapi import Depends, Request, Response
from fastapi_users import BaseUserManager, UUIDIDMixin, exceptions, models
from fastapi_users.db import SQLAlchemyUserDatabase
from dotenv import load_dotenv

# Impor model User dan skema UserCreate yang sudah dimodifikasi
try:
    from models.user_models import User, get_user_db, UserCreate as AppUserCreate
except ImportError:
    print("Gagal impor dari models.user_models di auth.manager")
    raise

load_dotenv()
SECRET = os.getenv("SECRET_KEY", "DEFAULT_FALLBACK_SECRET_KEY_CHANGE_ME")
if SECRET == "DEFAULT_FALLBACK_SECRET_KEY_CHANGE_ME":
    print("PERINGATAN: Menggunakan SECRET_KEY fallback. Harap set di .env!")


class UserManager(UUIDIDMixin, BaseUserManager[User, uuid.UUID]):
    reset_password_token_secret = SECRET
    verification_token_secret = SECRET

    async def on_after_register(self, user: User, request: Optional[Request] = None):
        print(f"User {user.id} ({user.email}) has registered with name: {user.name}.")

    async def on_after_forgot_password(self, user: User, token: str, request: Optional[Request] = None):
        print(f"User {user.id} forgot password. Token: {token}")

    async def on_after_request_verify(self, user: User, token: str, request: Optional[Request] = None):
        print(f"Verification requested for user {user.id}. Token: {token}")

    async def create(
        self,
        user_create: AppUserCreate, # Gunakan AppUserCreate dari user_models.py
        safe: bool = False,
        request: Optional[Request] = None,
    ) -> User:
        await self.validate_password(user_create.password, user_create)

        existing_user = await self.user_db.get_by_email(user_create.email)
        if existing_user is not None:
            raise exceptions.UserAlreadyExists()

        user_dict = (
            user_create.create_update_dict()
            if safe
            else user_create.create_update_dict_superuser()
        )
        password = user_dict.pop("password")
        user_dict["hashed_password"] = self.password_helper.hash(password)
        
        # Set default untuk field bawaan FastAPI-Users jika tidak ada di skema create kita
        user_dict.setdefault("is_active", True) # Default aktif
        user_dict.setdefault("is_verified", False) # Default belum terverifikasi

        # Ambil field profil tambahan dari user_create
        # (Nama field di AppUserCreate harus sama dengan nama kolom di model User)
        user_dict["name"] = user_create.name
        user_dict["education_level"] = user_create.education_level
        user_dict["institution_name"] = user_create.institution_name
        user_dict["favorite_subjects"] = user_create.favorite_subjects
        
        created_user = await self.user_db.create(user_dict)
        await self.on_after_register(created_user, request)
        return created_user

async def get_user_manager(user_db: SQLAlchemyUserDatabase = Depends(get_user_db)):
    yield UserManager(user_db)