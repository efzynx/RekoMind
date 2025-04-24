# File: main.py (DIPERBAIKI - Kembalikan @app.get("/"))

from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse, FileResponse # <-- Impor lagi
import os
from dotenv import load_dotenv

# Impor router API Kuis, History, dll.
from api.v1.api import api_router as api_router_v1

# Impor komponen FastAPI-Users
from auth.core import fastapi_users
from auth.strategy import auth_backend_jwt
from models.user_models import User, UserRead, UserCreate, UserUpdate, uuid # Pastikan uuid diimpor jika dipakai di skema

load_dotenv()
app = FastAPI(
    title="Interactive Quiz API with Auth",
    description="API untuk Kuis Pengetahuan Umum Interaktif dengan fitur Otentikasi Pengguna.",
    version="0.3.2" # Versi baru
)

# --- Konfigurasi CORS ---
origins = [
    "http://localhost",
    "http://127.0.0.1:5500", # Ganti port jika Live Server Anda beda
    # Tambahkan URL Vercel/domain production Anda nanti:
    # "https://rekomind.vercel.app",
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

# 1. Sajikan index.html untuk root path ('/') <<< DIKEMBALIKAN
@app.get("/", response_class=HTMLResponse, include_in_schema=False)
async def serve_spa():
    """Menyajikan file index.html utama."""
    index_path = os.path.join(STATIC_DIR, "index.html")
    if not os.path.exists(index_path):
        raise HTTPException(status_code=404, detail="Frontend entry point (index.html) not found in static folder.")
    return FileResponse(index_path)

# 2. Mount direktori 'static' ke path '/static' untuk file lain (js, css, img)
# Pastikan folder 'static' ada di root proyek
if not os.path.isdir(STATIC_DIR):
    print(f"PERINGATAN: Direktori static '{STATIC_DIR}' tidak ditemukan.")
else:
     app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

# --- Akhir Sajikan Frontend ---

# Endpoint contoh (opsional)
@app.get("/api/v1/hello", tags=["Example"])
async def hello_world(): return {"message": "Hello World"}
@app.get("/api/v1/protected-route", tags=["Example"])
async def protected_route(user: User = Depends(fastapi_users.current_user(active=True))): return {"message": f"Hello {user.email}!"}