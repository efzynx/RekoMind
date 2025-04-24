# File: alembic/env.py (Revisi Logika Pengambilan DB URL)

import asyncio
import os
import sys
from logging.config import fileConfig

from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy import pool

from alembic import context

# --- TAMBAHAN KODE PATH ---
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if project_root not in sys.path:
    print(f"Menambahkan {project_root} ke sys.path")
    sys.path.insert(0, project_root)
# -------------------------

# --- Impor Base dan Modul Model Lainnya ---
try:
    from models.base import Base
    import models.user_models
    import models.history_models
    # import models.quiz_models
except ImportError as e:
    print(f"GAGAL Impor: {e}")
    print("Pastikan Base dan file model lain bisa diimpor.")
    print(f"sys.path saat ini: {sys.path}")
    raise
# -----------------------------------------

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata

# --- LOGIKA PENGAMBILAN DB URL ---
db_url = os.getenv("DATABASE_URL")

if not db_url:
    # Jika tidak ada di env var, baru coba ambil dari alembic.ini
    print("DATABASE_URL environment variable not found, trying alembic.ini...")
    db_url = config.get_main_option("sqlalchemy.url")
    if not db_url:
        raise ValueError("URL Database tidak diatur di alembic.ini (sqlalchemy.url) atau environment variable DATABASE_URL")
else:
    # Jika ada di env var, set juga ke config agar Alembic tahu (opsional tapi baik)
    print(f"Using DATABASE_URL from environment variable: ...@{db_url.split('@')[-1]}") # Cetak bagian host/db saja
    config.set_main_option("sqlalchemy.url", db_url)
# -------------------------------------------

def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    context.configure(
        url=db_url, target_metadata=target_metadata,
        literal_binds=True, dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()

def do_run_migrations(connection):
    """Helper function untuk menjalankan migrasi secara sinkron."""
    context.configure(connection=connection, target_metadata=target_metadata)
    print("Memulai transaksi migrasi...")
    with context.begin_transaction():
        print("Menjalankan migrasi...")
        context.run_migrations()
        print("Migrasi selesai.")
    print("Transaksi migrasi selesai.")

async def run_migrations_online() -> None:
    """Run migrations in 'online' mode using an async engine."""
    # Gunakan db_url yang sudah ditentukan di atas
    print(f"Menghubungkan ke database: ...@{db_url.split('@')[-1]}") # Cetak bagian host/db saja
    connectable = create_async_engine(db_url, poolclass=pool.NullPool)

    try:
        async with connectable.connect() as connection:
            print("Koneksi berhasil. Menjalankan migrasi sinkron...")
            await connection.run_sync(do_run_migrations)
    except Exception as e:
        print(f"Gagal menghubungkan atau menjalankan migrasi: {e}")
        import traceback
        traceback.print_exc()
    finally:
        print("Menutup koneksi engine...");
        await connectable.dispose();
        print("Koneksi engine ditutup.")

if context.is_offline_mode():
    print("Menjalankan migrasi dalam mode offline...");
    run_migrations_offline();
    print("Migrasi offline selesai.")
else:
    print("Menjalankan migrasi dalam mode online...");
    try:
        asyncio.run(run_migrations_online());
        print("Migrasi online selesai.")
    except Exception as e:
        print(f"Terjadi error saat menjalankan asyncio.run(run_migrations_online): {e}")
        import traceback
        traceback.print_exc()