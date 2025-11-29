FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

# Dependencies for Playwright + OCR + audio
RUN apt-get update && apt-get install -y \
    wget curl git unzip ffmpeg tesseract-ocr \
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 \
    libgtk-3-0 libgbm1 libasound2 libxcomposite1 libxdamage1 \
    libxrandr2 libxfixes3 libpango-1.0-0 libcairo2 \
    && rm -rf /var/lib/apt/lists/*

# Install playwright browsers
RUN pip install playwright && playwright install --with-deps chromium

# Install uv
RUN pip install uv

WORKDIR /app
COPY . .

# Install dependencies
RUN uv sync --frozen

EXPOSE 7860

# ⭐ RUN FASTAPI WITH YOUR EXISTING STRUCTURE
CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
