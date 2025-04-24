# File: main.py (DIPERBAIKI - Kembalikan @app.get("/") dan app.mount)

from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles # <-- Impor lagi
from fastapi.responses import HTMLResponse, FileResponse # <-- Impor lagi
import os
from dotenv import load_dotenv

# Impor router API Kuis, History, dll.
from api.v1.api import api_router as api_router_v1

# Impor komponen FastAPI-Users
from auth.core import fastapi_users
from auth.strategy import auth_backend_jwt
from models.user_models import User, UserRead, UserCreate, UserUpdate, uuid

load_dotenv()
app = FastAPI(
    title="Interactive Quiz API with Auth",
    description="API untuk Kuis Pengetahuan Umum Interaktif.",
    version="0.3.4" # Versi baru lagi
)

# --- Konfigurasi CORS ---
origins = [
    "http://localhost",
    "http://127.0.0.1:5500",
    "https://rekomind.vercel.app", # Ganti jika URL Vercel Anda berbeda
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
app.include_router( fastapi_users.get_auth_router(auth_backend_jwt), prefix="/api/v1/auth", tags=["Auth"])
app.include_router( fastapi_users.get_register_router(UserRead, UserCreate), prefix="/api/v1/auth", tags=["Auth"])
app.include_router( fastapi_users.get_reset_password_router(), prefix="/api/v1/auth", tags=["Auth"])
app.include_router( fastapi_users.get_verify_router(UserRead), prefix="/api/v1/auth", tags=["Auth"])
app.include_router( fastapi_users.get_users_router(UserRead, UserUpdate), prefix="/api/v1/users", tags=["Users"])
app.include_router( api_router_v1, prefix="/api/v1") # /quiz, /history, /recommendations
# -----------------------------------

# --- Sajikan Frontend Statis ---

STATIC_DIR = "static" # Nama folder tempat index.html dan script.js

# 1. Mount direktori 'static' ke path '/static' untuk file js, css, img
# Pastikan folder 'static' ada di root proyek sejajar dengan main.py
if not os.path.isdir(STATIC_DIR):
    print(f"PERINGATAN: Direktori static '{STATIC_DIR}' tidak ditemukan.")
else:
     # html=True BISA dihilangkan jika kita handle root secara manual
     app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

# 2. Sajikan index.html untuk root path ('/') <<< DIKEMBALIKAN
@app.get("/", response_class=HTMLResponse, include_in_schema=False)
async def serve_frontend_entrypoint():
    """Menyajikan file index.html utama dari folder static."""
    index_path = os.path.join(STATIC_DIR, "index.html")
    if not os.path.exists(index_path):
        # Jika index.html tidak ada di static, beri 404
        raise HTTPException(status_code=404, detail="Frontend entry point (static/index.html) not found.")
    return FileResponse(index_path)
# -----------------------------------------------------------

# Endpoint contoh (opsional)
@app.get("/api/v1/hello", tags=["Example"])
async def hello_world(): return {"message": "Hello World"}
@app.get("/api/v1/protected-route", tags=["Example"])
async def protected_route(user: User = Depends(fastapi_users.current_user(active=True))): return {"message": f"Hello {user.email}!"}