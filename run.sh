#!/usr/bin/env bash
set -e

# -------------------------------------------------------------------
# EMHASS runtime-only start script for HAOS add-on
# Goal:
# - NEVER call Home Assistant / Supervisor API (avoid 401 + instability)
# - Use ONLY local config (persisted in /share/config.json)
# - Serve EMHASS FastAPI app on :5000
# -------------------------------------------------------------------

# 1) Disable Supervisor autodetect inside EMHASS
unset SUPERVISOR_TOKEN || true
unset HASSIO_TOKEN || true
export SUPERVISOR_TOKEN=""
export HASSIO_TOKEN=""

# 2) Provide minimal add-on options file (some EMHASS code paths read this)
mkdir -p /data
cat > /data/options.json <<'JSON'
{
  "url": "empty",
  "key": "empty"
}
JSON

# 3) Ensure a local config exists and is reachable where EMHASS looks for it
# We persist the real config in /share (so you can edit it from HA File Editor),
# and symlink it into /data (because EMHASS often defaults to /data).
if [ ! -f /share/config.json ]; then
  cat > /share/config.json <<'JSON'
{
  "data_path": "/share",
  "log_level": "INFO",

  "inverter_is_hybrid": true,
  "inverter_ac_output_max": 10000,
  "inverter_ac_input_max": 10000,
  "inverter_efficiency_dc_ac": 1,
  "inverter_efficiency_ac_dc": 1,

  "set_use_battery": true,
  "battery_nominal_energy_capacity": 9900,
  "battery_discharge_power_max": 6000,
  "battery_charge_power_max": 6000,
  "battery_discharge_efficiency": 0.95,
  "battery_charge_efficiency": 0.95,
  "battery_minimum_state_of_charge": 0.10,
  "battery_maximum_state_of_charge": 1.00,
  "battery_target_state_of_charge": 0.80,

  "compute_curtailment": false
}
JSON
fi

ln -sf /share/config.json /data/config.json

# 4) Start EMHASS web server (FastAPI) via uvicorn
exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
