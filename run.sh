#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# EMHASS Runtime Only (stable) - start EMHASS the "normal" way
# so naive-mpc-optim can access HA via Supervisor API.
#
# Prereq in add-on config.yaml:
#   hassio_api: true
#   homeassistant_api: true
#   auth_api: true
#
# This is the simplest, least-fragile run.sh.
# ------------------------------------------------------------

exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
