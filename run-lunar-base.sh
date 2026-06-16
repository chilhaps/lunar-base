#!/usr/bin/env bash

if [ ! -d .venv ]; then
    echo Virtual environment not found. Run setup.sh first.
    exit 1
fi

source .venv/bin/activate

echo === Lunar Base ===
python -m uvicorn web.app:app --host 0.0.0.0 --port 9088
