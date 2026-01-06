#!/usr/bin/env bash
set -e

# Hard runtime-only: prevent EMHASS from using Supervisor API autodetect
unset SUPERVISOR_TOKEN
unset HASSIO_TOKEN
export SUPERVISOR_TOKEN=""
export HASSIO_TOKEN=""

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



exec uvicorn emhass.web_server:app \
  --host 0.0.0.0 \
  --port 5000 \
  --log-level info
