#!/usr/bin/env bash
set -e

# -------------------------------------------------------------------
# EMHASS runtime-only start script for HAOS add-on
# - Prevent Supervisor/HA autodetect (no calls to supervisor/core/api)
# - Use ONLY a runtime-only local config file in /share
# - Serve EMHASS FastAPI app on :5000
# -------------------------------------------------------------------

# 1) Disable Supervisor autodetect inside EMHASS
unset SUPERVISOR_TOKEN || true
unset HASSIO_TOKEN || true
export SUPERVISOR_TOKEN=""
export HASSIO_TOKEN=""

# 2) Minimal add-on options (some code paths look at this)
mkdir -p /data
cat > /data/options.json <<'JSON'
{
  "url": "empty",
  "key": "empty"
}
JSON

# 3) Ensure runtime-only config exists in /share (DO NOT touch /share/config.json)
RUNTIME_CFG="/share/config_runtime_only.json"

if [ ! -f "${RUNTIME_CFG}" ]; then
  cat > "${RUNTIME_CFG}" <<'JSON'
{
  "data_path": "/share",
  "logging_level": "INFO",

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

# EMHASS tends to look for /data/config.json -> point it to our runtime-only config
ln -sf "${RUNTIME_CFG}" /data/config.json

# 4) Start EMHASS FastAPI app
exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
