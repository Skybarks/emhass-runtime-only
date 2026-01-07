#!/bin/sh
set -eu

exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
