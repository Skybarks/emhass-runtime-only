#!/usr/bin/env bash
set -e

python - <<'PY'
from emhass.web_server import WebServer

srv = WebServer(
    data_path="/share",
    log_level="INFO",
    use_websocket=False,
    hass_url="empty",
    hass_token="empty",
)
srv.run(host="0.0.0.0", port=5000)
PY
