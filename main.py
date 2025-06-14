# File: main.py (DIPERBAIKI - Kembalikan @app.get("/") dan app.mount)

from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles # <-- Impor lagi
from fastapi.responses import HTMLResponse, FileResponse # <-- Impor lagi
from contextlib import asynccontextmanager # Untuk lifespan event
# ... (Impor lain tetap sama) ...
from utils.ai_models import ensure_ai_model_loaded

import os
from dotenv import load_dotenv

# Impor router API Kuis, History, dll.
from api.v1.api import api_router as api_router_v1

# Impor komponen FastAPI-Users
from auth.core import fastapi_users
from auth.strategy import auth_backend_jwt
from models.user_models import User, UserRead, UserCreate, UserUpdate, uuid

# --- Lifespan Event untuk Startup & Shutdown ---
@asynccontextmanager
async def lifespan(app: FastAPI):
    print("Aplikasi FastAPI memulai...")
    print("Memastikan model AI (Sentence Transformer) dimuat...")
    try:
        ensure_ai_model_loaded() # Panggil fungsi ini untuk memuat model saja
        print("Model AI siap.")
    except Exception as e:
        print(f"ERROR saat memuat model AI: {e}")
        import traceback
        traceback.print_exc()
    yield
    print("Aplikasi FastAPI berhenti...")

app = FastAPI(
    title="Interactive Quiz API with AI Recommender",
    description="API Kuis dengan Rekomendasi AI.",
    version="0.5.0",
    lifespan=lifespan # Tambahkan lifespan event handler
)

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


# if os.getenv("ENV") != "production":
#     # Jalankan migrasi hanya di lokal/dev
#     from alembic.config import CommandLine
#     cli = CommandLine()
#     cli.run_cmd(["upgrade", "head"])



# --- Sajikan Frontend Statis ---

STATIC_DIR = "public" # Nama folder tempat index.html dan script.js

# 1. Mount direktori 'public' ke path '/public' untuk file js, css, img
# Pastikan folder 'public' ada di root proyek sejajar dengan main.py
if not os.path.isdir(STATIC_DIR):
    print(f"PERINGATAN: Direktori public '{STATIC_DIR}' tidak ditemukan.")
else:
     # html=True BISA dihilangkan jika kita handle root secara manual
     app.mount("/public", StaticFiles(directory=STATIC_DIR), name="public")

# 2. Sajikan index.html untuk root path ('/') <<< DIKEMBALIKAN
@app.get("/", response_class=HTMLResponse, include_in_schema=False)
async def serve_frontend_entrypoint():
    """Menyajikan file index.html utama dari folder public."""
    index_path = os.path.join(STATIC_DIR, "index.html")
    if not os.path.exists(index_path):
        # Jika index.html tidak ada di public, beri 404
        raise HTTPException(status_code=404, detail="Frontend entry point (public/index.html) not found.")
    return FileResponse(index_path)
# -----------------------------------------------------------

# Endpoint contoh (opsional)
@app.get("/api/v1/hello", tags=["Example"])
async def hello_world(): return {"message": "Hello World"}
@app.get("/api/v1/protected-route", tags=["Example"])
async def protected_route(user: User = Depends(fastapi_users.current_user(active=True))): return {"message": f"Hello {user.email}!"}