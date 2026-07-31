#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

echo "HTTP CHECK"
echo "----------"

echo "[INFO] Checking HTTP response"

curl -I -L --max-time 10 "https://$TARGET" 2>/dev/null
