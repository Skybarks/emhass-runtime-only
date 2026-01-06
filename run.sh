#!/usr/bin/env bash
set -e

# Force runtime-only: prevent EMHASS from calling supervisor/core/api (401)
# EMHASS addon-mode reads /data/options.json for url/key.
mkdir -p /data
cat > /data/options.json <<'JSON'
{
  "url": "empty",
  "key": "empty"
}
JSON

exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
