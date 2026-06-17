# syntax=docker/dockerfile:1

FROM golang:1.22 AS builder
WORKDIR /src
COPY tools/grant/src/*.go ./
ARG LUNAR_TEAR_DIR=/lunar-tear
RUN mkdir -p /out
RUN --mount=type=bind,source=${LUNAR_TEAR_DIR},target=/mnt/lunar-tear,readonly \
    mkdir -p /tmp/lunar-tear/server/cmd/lunar-base-grant && \
    cp -a /mnt/lunar-tear/. /tmp/lunar-tear/ && \
    cp *.go /tmp/lunar-tear/server/cmd/lunar-base-grant/ && \
    cd /tmp/lunar-tear/server && \
    go build -o /out/grant ./cmd/lunar-base-grant/

FROM python:3.12-slim
WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

COPY web/requirements.txt /app/web/requirements.txt
RUN python -m pip install --upgrade pip \
    && python -m pip install -r /app/web/requirements.txt

COPY --from=builder /out/grant /app/tools/grant/grant
COPY . /app

EXPOSE 8888
CMD ["uvicorn", "web.app:app", "--host", "0.0.0.0", "--port", "8888"]
