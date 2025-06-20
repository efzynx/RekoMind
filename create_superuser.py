import asyncio
import os
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy import text
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL") # Gunakan URL sync untuk skrip sederhana ini
# Pastikan Anda punya DATABASE_URL_SYNC=postgresql+psycopg2://... di .env
# atau sesuaikan dengan DATABASE_URL dan gunakan asyncpg

async def make_user_superuser(email: str):
    if not DATABASE_URL:
        print("DATABASE_URL_SYNC tidak diset di .env")
        return
    
    engine = create_async_engine(DATABASE_URL) # Use asyncpg driver

    async with engine.connect() as conn:
        try:
            # Perintah SQL untuk mengupdate flag is_superuser
            stmt = text("UPDATE \"user\" SET is_superuser = TRUE WHERE email = :email")
            await conn.execute(stmt, {"email": email})
            await conn.commit()
            print(f"User dengan email '{email}' telah berhasil dijadikan superuser.")
        except Exception as e:
            print(f"Gagal menjadikan user superuser: {e}")

if __name__ == "__main__":
    user_email_to_promote = input("Masukkan email user yang akan dijadikan superuser: ")
    if user_email_to_promote:
        asyncio.run(make_user_superuser(user_email_to_promote))