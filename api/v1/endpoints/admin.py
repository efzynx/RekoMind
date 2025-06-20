# File: api/v1/endpoints/admin.py (File BARU)

from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
import io

from sqlalchemy.ext.asyncio import AsyncSession
try:
    from models.user_models import User, get_async_session
    from services.admin_service import get_all_answer_details_as_csv
    from auth.core import fastapi_users
except ImportError:
    # Fallback
    User = type("User", (), {})
    async def get_async_session(): 
        yield
    
    async def get_all_answer_details_as_csv(db):
        return ""
    
    class FastAPIUsers:
        def current_user(self, active, superuser):
            return None
    
    fastapi_users = FastAPIUsers()

router = APIRouter()

# Dependency untuk memastikan hanya superuser yang bisa akses
current_superuser = fastapi_users.current_user(active=True, superuser=True)

@router.get(
    "/download-history",
    summary="Unduh Seluruh Riwayat Jawaban (Admin Only)",
    description="Mengunduh seluruh data dari tabel user_answer_detail dalam format CSV."
)
async def download_answer_history(
    admin: User = Depends(current_superuser),
    db: AsyncSession = Depends(get_async_session)
):
    """
    Endpoint ini hanya bisa diakses oleh superuser.
    Ia akan membuat file CSV dari riwayat jawaban dan mengirimkannya sebagai download.
    """
    print(f"ADMIN ACCESS: User {admin.email} meminta unduh dataset riwayat.")
    try:
        csv_data = await get_all_answer_details_as_csv(db)
        if not csv_data:
            raise HTTPException(status_code=404, detail="Tidak ada data riwayat jawaban untuk diunduh.")
        
        # Buat response yang akan diunduh sebagai file
        response = StreamingResponse(
            io.StringIO(csv_data),
            media_type="text/csv",
            headers={"Content-Disposition": "attachment; filename=rekomind_answer_history.csv"}
        )
        return response
    except Exception as e:
        print(f"ADMIN ERROR: Gagal membuat file CSV: {e}")
        raise HTTPException(status_code=500, detail="Gagal memproses data untuk diunduh.")
