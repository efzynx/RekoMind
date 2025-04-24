# File: Dockerfile

# Gunakan base image Python resmi yang slim
FROM python:3.11-slim

# Set working directory di dalam container
WORKDIR /app

# Set environment variable agar output Python langsung tampil (buffered=0)
ENV PYTHONUNBUFFERED=1
# Set environment variable untuk port (opsional, bisa di set saat run)
ENV PORT=8000

# Install OS dependencies jika ada (misal jika perlu build library tertentu)
# RUN apt-get update && apt-get install -y --no-install-recommends gcc build-essential && rm -rf /var/lib/apt/lists/*

# Upgrade pip dan install dependensi Python
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Salin seluruh kode aplikasi ke working directory
COPY . .
COPY alembic alembic
COPY alembic.ini alembic.ini


# Beri tahu Docker port mana yang akan diekspos oleh container saat runtime
EXPOSE ${PORT}

# Perintah default untuk menjalankan aplikasi saat container start
# Menggunakan Uvicorn, bind ke 0.0.0.0 agar bisa diakses dari luar container
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]