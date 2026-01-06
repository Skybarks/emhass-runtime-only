#!/usr/bin/env bash
set -e

# Force EMHASS to use Supervisor Core API (verified working)
export EMHASS_URL="http://supervisor/core/api"
export EMHASS_KEY="${SUPERVISOR_TOKEN}"
export EMHASS_USE_WEBSOCKET="false"

exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
