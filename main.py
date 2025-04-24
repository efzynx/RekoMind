# File: main.py (DIMODIFIKASI - Tambah penyajian file statis)

from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles # <-- Impor untuk file statis
from fastapi.responses import HTMLResponse, FileResponse # <-- Impor untuk respons file/HTML
import os # <-- Impor os jika belum ada

# Impor router API Kuis, History, dll.
from api.v1.api import api_router as api_router_v1

# Impor komponen FastAPI-Users
from auth.core import fastapi_users
from auth.strategy import auth_backend_jwt # Sesuaikan jika pakai backend lain
from models.user_models import User, UserRead, UserCreate, UserUpdate, uuid

# Muat environment variables (jika pakai .env)
from dotenv import load_dotenv
load_dotenv()

# Inisialisasi Aplikasi FastAPI
app = FastAPI(
    title="Interactive Quiz API with Auth",
    description="API untuk Kuis Pengetahuan Umum Interaktif dengan fitur Otentikasi Pengguna.",
    version="0.3.0" # Versi baru karena ada Docker & static files
)

# --- Konfigurasi CORS ---
origins = [
    "http://localhost",
    "http://127.0.0.1:5500", # Ganti port jika Live Server Anda beda
    # Tambahkan origin Vercel Anda nanti di sini
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

# --- Sajikan Frontend Statis ---

# 1. Mount direktori 'static' ke path '/static'
# Ini akan membuat file di dalam folder 'static' bisa diakses
# Contoh: static/script.js -> http://localhost:8000/static/script.js
# PENTING: Pastikan folder 'static' ada di root proyek sejajar dengan main.py
STATIC_DIR = "static"
if not os.path.isdir(STATIC_DIR):
    print(f"PERINGATAN: Direktori static '{STATIC_DIR}' tidak ditemukan. Frontend tidak akan tersaji.")
    # Anda bisa membuat direktori jika tidak ada: os.makedirs(STATIC_DIR, exist_ok=True)
else:
     app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

# 2. Sajikan index.html untuk root path ('/')
@app.get("/", response_class=HTMLResponse, include_in_schema=False)
async def read_index():
    """Menyajikan file index.html utama."""
    index_path = os.path.join(STATIC_DIR, "index.html")
    if not os.path.exists(index_path):
        raise HTTPException(status_code=404, detail="index.html tidak ditemukan di folder static.")
    # Kembalikan sebagai FileResponse agar browser tahu tipenya HTML
    return FileResponse(index_path)

# --- Akhir Sajikan Frontend ---

# Endpoint contoh (opsional)
@app.get("/api/v1/hello", tags=["Example"])
async def hello_world():
    return {"message": "Hello World"}

# Endpoint contoh terproteksi (opsional)
@app.get("/api/v1/protected-route", tags=["Example"])
async def protected_route(user: User = Depends(fastapi_users.current_user(active=True))):
    return {"message": f"Hello {user.email}! Ini route terproteksi."}

# (Event startup/shutdown jika ada, bisa dihapus jika tidak perlu)