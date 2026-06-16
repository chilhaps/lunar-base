FROM python:3.14-slim

WORKDIR /usr/src/app
ENV PYTHONUNBUFFERED=1

RUN python -m pip install --upgrade pip
COPY web/requirements.txt ./web/requirements.txt
RUN pip install --no-cache-dir -r web/requirements.txt

EXPOSE 8888
CMD ["uvicorn", "web.app:app", "--host", "0.0.0.0", "--port", "8888"]
