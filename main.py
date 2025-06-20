from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse, FileResponse
from contextlib import asynccontextmanager

from dotenv import load_dotenv
import os

from utils.ai_models import ensure_ai_model_loaded
from api.v1.api import api_router as api_router_v1
from auth.core import fastapi_users
from auth.strategy import auth_backend_jwt
from models.user_models import User, UserRead, UserCreate, UserUpdate, uuid

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("Aplikasi FastAPI memulai...")
    try:
        ensure_ai_model_loaded()
        print("Model AI siap.")
    except Exception as e:
        print(f"ERROR saat memuat model AI: {e}")
    yield
    print("Aplikasi FastAPI berhenti...")

app = FastAPI(
    title="Interactive Quiz API with Auth",
    description="API untuk Kuis Pengetahuan Umum Interaktif.",
    version="0.3.4",
    lifespan=lifespan
)

# CORS
origins = [
    "http://localhost",
    "http://127.0.0.1:5500",
    "https://rekomind.vercel.app"
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# FastAPI Users
app.include_router(fastapi_users.get_auth_router(auth_backend_jwt), prefix="/api/v1/auth", tags=["Auth"])
app.include_router(fastapi_users.get_register_router(UserRead, UserCreate), prefix="/api/v1/auth", tags=["Auth"])
app.include_router(fastapi_users.get_reset_password_router(), prefix="/api/v1/auth", tags=["Auth"])
app.include_router(fastapi_users.get_verify_router(UserRead), prefix="/api/v1/auth", tags=["Auth"])
app.include_router(fastapi_users.get_users_router(UserRead, UserUpdate), prefix="/api/v1/users", tags=["Users"])

# ✅ Sertakan semua router kamu
app.include_router(api_router_v1, prefix="/api/v1")

# Mount frontend
STATIC_DIR = "public"
if not os.path.isdir(STATIC_DIR):
    print(f"PERINGATAN: Direktori public '{STATIC_DIR}' tidak ditemukan.")
else:
    app.mount("/public", StaticFiles(directory=STATIC_DIR), name="public")

@app.get("/", response_class=HTMLResponse, include_in_schema=False)
async def serve_frontend_entrypoint():
    index_path = os.path.join(STATIC_DIR, "index.html")
    if not os.path.exists(index_path):
        raise HTTPException(status_code=404, detail="Frontend entry point (public/index.html) not found.")
    return FileResponse(index_path)

@app.get("/api/v1/hello", tags=["Example"])
async def hello_world():
    return {"message": "Hello World"}

@app.get("/api/v1/protected-route", tags=["Example"])
async def protected_route(user: User = Depends(fastapi_users.current_user(active=True))):
    return {"message": f"Hello {user.email}!"}
