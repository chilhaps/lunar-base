#!/usr/bin/env bash
set -euo pipefail

if [ -n "${LUNAR_TEAR_DIR:-}" ] && [ -d "$LUNAR_TEAR_DIR/server" ]; then
  grant_path="/app/tools/grant/grant"
  if [ ! -f "$grant_path" ]; then
    if command -v go >/dev/null 2>&1 && [ -f "$LUNAR_TEAR_DIR/server/go.mod" ]; then
      echo "Building lunar-base grant shim..."
      mkdir -p "$LUNAR_TEAR_DIR/server/cmd/lunar-base-grant"
      cp /app/tools/grant/src/*.go "$LUNAR_TEAR_DIR/server/cmd/lunar-base-grant/"
      pushd "$LUNAR_TEAR_DIR/server" >/dev/null
      go build -o /app/tools/grant/grant ./cmd/lunar-base-grant/
      popd >/dev/null
      echo "Built grant shim at $grant_path"
    else
      echo "grant shim missing and Go is unavailable; please install Go or build the shim on the host." >&2
    fi
  fi
fi

exec uvicorn web.app:app --host 0.0.0.0 --port 8888
