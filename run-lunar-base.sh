#!/usr/bin/env bash

if [ ! -d .venv ]; then
    echo Virtual environment not found. Run setup.sh first.
    exit 1
fi

source .venv/bin/activate

HOST=127.0.0.1
PORT=8888

while [ "$#" -gt 0 ]; do
    case "$1" in
        --host)
            shift
            if [ -z "$1" ]; then
                echo "Usage: $0 [--host HOST] [--port PORT]"
                exit 1
            fi
            HOST="$1"
            ;;
        --port)
            shift
            if [ -z "$1" ]; then
                echo "Usage: $0 [--host HOST] [--port PORT]"
                exit 1
            fi
            PORT="$1"
            ;;
        *)
            echo "Usage: $0 [--host HOST] [--port PORT]"
            exit 1
            ;;
    esac
    shift
done

echo === Lunar Base ===
echo Open http://$HOST:$PORT in your browser.
python -m uvicorn web.app:app --host "$HOST" --port "$PORT"
