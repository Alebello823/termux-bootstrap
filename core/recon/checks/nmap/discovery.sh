#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"
OUTPUT="$2"

echo "NMAP FAST DISCOVERY"
echo "-------------------"

if [ -z "$TARGET" ]; then
    echo "[WARN] Target missing"
    exit 1
fi


echo "[INFO] Fast port discovery"
echo "[INFO] Mode: all TCP ports"


nmap \
-Pn \
-n \
-T4 \
--min-rate 1000 \
--max-retries 3 \
--open \
-p- \
"$TARGET" \
-oN "$OUTPUT"


EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 0 ]; then
    echo "[OK] Discovery completed"
else
    echo "[ERROR] Nmap failed (exit=$EXIT_CODE)"
    exit "$EXIT_CODE"
fi
