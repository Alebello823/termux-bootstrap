#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"
PORTS="$2"

echo "NMAP SERVICE SCAN"
echo "-----------------"

if [ -z "$TARGET" ]; then
    echo "[WARN] Target missing"
    exit 1
fi

if [ -z "$PORTS" ]; then
    echo "[WARN] Ports missing"
    exit 1
fi

if ! command -v nmap >/dev/null 2>&1; then
    echo "[WARN] nmap missing"
    exit 1
fi


echo "[INFO] Target: $TARGET"
echo "[INFO] Ports: $PORTS"

nmap \
-sT \
-sV \
-sC \
-p "$PORTS" \
"$TARGET"


echo
echo "[OK] Service scan completed"
