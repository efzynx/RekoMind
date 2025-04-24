# File: main.py (DIPERBAIKI - Hapus SEMUA static file handling)

from fastapi import FastAPI, Depends # Hanya impor yang perlu untuk API
from fastapi.middleware.cors import CORSMiddleware
# Hapus: from fastapi.staticfiles import StaticFiles
# Hapus: from fastapi.responses import HTMLResponse, FileResponse
# Hapus: import os
from dotenv import load_dotenv

# Impor router API
from api.v1.api import api_router as api_router_v1

# Impor komponen FastAPI-Users
from auth.core import fastapi_users
from auth.strategy import auth_backend_jwt
from models.user_models import User, UserRead, UserCreate, UserUpdate, uuid

load_dotenv()
app = FastAPI(
    title="Interactive Quiz API with Auth",
    description="API untuk Kuis Pengetahuan Umum Interaktif.",
    version="0.3.3" # Versi baru
)

# --- Konfigurasi CORS ---
origins = [
    "http://localhost",
    "http://127.0.0.1:5500",
    "https://rekomind.vercel.app", # Tambahkan URL Vercel Anda
    # Tambahkan origin lain jika perlu
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# -----------------------

# --- Sertakan Router API Backend Anda ---
# (Auth, Users, Quiz, History, Recommendations)
app.include_router( fastapi_users.get_auth_router(auth_backend_jwt), prefix="/api/v1/auth", tags=["Auth"])
app.include_router( fastapi_users.get_register_router(UserRead, UserCreate), prefix="/api/v1/auth", tags=["Auth"])
app.include_router( fastapi_users.get_reset_password_router(), prefix="/api/v1/auth", tags=["Auth"])
app.include_router( fastapi_users.get_verify_router(UserRead), prefix="/api/v1/auth", tags=["Auth"])
app.include_router( fastapi_users.get_users_router(UserRead, UserUpdate), prefix="/api/v1/users", tags=["Users"])
app.include_router( api_router_v1, prefix="/api/v1") # Ini berisi /quiz, /history, /recommendations
# -----------------------------------

# --- HAPUS SEMUA BAGIAN STATIC FILES DARI SINI ---
# Hapus app.mount(...)
# Hapus @app.get("/")
# ----------------------------------------------

# Endpoint contoh (opsional)
@app.get("/api/v1/hello", tags=["Example"])
async def hello_world(): return {"message": "Hello World"}
@app.get("/api/v1/protected-route", tags=["Example"])
async def protected_route(user: User = Depends(fastapi_users.current_user(active=True))): return {"message": f"Hello {user.email}!"}