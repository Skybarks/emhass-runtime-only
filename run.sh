#!/usr/bin/env bash
set -euo pipefail

# Runtime-only: erzwinge lokale config, kein Supervisor/HA fetch
mkdir -p /data
cat >/data/options.json <<'JSON'
{"url":"empty","key":"empty"}
JSON

exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
