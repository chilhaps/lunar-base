# syntax=docker/dockerfile:1
FROM python:3.12-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

COPY web/requirements.txt /app/web/requirements.txt
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential python3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --upgrade pip \
    && python -m pip install -r /app/web/requirements.txt

COPY . /app

EXPOSE 8888

CMD ["uvicorn", "web.app:app", "--host", "0.0.0.0", "--port", "8888"]
