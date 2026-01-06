mkdir -p /data
cat > /data/options.json <<JSON
{
  "url": "http://supervisor/core/api",
  "key": "${SUPERVISOR_TOKEN}",
  "use_websocket": false,
  "data_path": "/share",
  "log_level": "INFO"
}
JSON
