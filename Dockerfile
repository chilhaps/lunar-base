# syntax=docker/dockerfile:1

FROM golang:1.22 AS builder
WORKDIR /src
COPY lunar-base/tools/grant/src/*.go ./
COPY lunar-tear/server/go.mod /tmp/lunar-tear/server/go.mod
COPY lunar-tear/server/go.sum /tmp/lunar-tear/server/go.sum
COPY lunar-tear/server/internal /tmp/lunar-tear/server/internal
RUN mkdir -p /out
RUN mkdir -p /tmp/lunar-tear/server/cmd/lunar-base-grant && \
    cp *.go /tmp/lunar-tear/server/cmd/lunar-base-grant/ && \
    cd /tmp/lunar-tear/server && \
    go build -o /out/grant ./cmd/lunar-base-grant/

FROM python:3.12-slim
WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

COPY lunar-base/web/requirements.txt /app/web/requirements.txt
RUN python -m pip install --upgrade pip \
    && python -m pip install -r /app/web/requirements.txt

COPY --from=builder /out/grant /app/tools/grant/grant
COPY lunar-base /app

EXPOSE 8888
CMD ["uvicorn", "web.app:app", "--host", "0.0.0.0", "--port", "8888"]
