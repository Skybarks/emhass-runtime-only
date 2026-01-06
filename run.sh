#!/usr/bin/env bash
set -e

# Hard runtime-only: prevent EMHASS from using Supervisor API autodetect
unset SUPERVISOR_TOKEN
unset HASSIO_TOKEN
export SUPERVISOR_TOKEN=""
export HASSIO_TOKEN=""

# Provide addon-style options for modules that read it
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
