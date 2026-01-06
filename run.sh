#!/usr/bin/env bash
set -e

# Hard runtime-only: prevent EMHASS from using Supervisor API autodetect
unset SUPERVISOR_TOKEN
unset HASSIO_TOKEN
export SUPERVISOR_TOKEN=""
export HASSIO_TOKEN=""

cat > /data/config.json <<'JSON'
{
  "data_path": "/share",
  "log_level": "INFO",
  "retrieve_hass_conf": {
    "method": "skip"
  }
}
JSON


exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
