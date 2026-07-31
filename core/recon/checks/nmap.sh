#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

echo "NMAP CHECK"
echo "----------"

if ! command -v nmap >/dev/null 2>&1; then
    echo "[WARN] nmap not installed"
    exit 0
fi

if [ -z "$TARGET" ]; then
    echo "[WARN] Target missing"
    exit 1
fi


echo "[INFO] Target: $TARGET"
echo "[INFO] Running TCP service detection"


nmap \
-sT \
-sV \
-sC \
--version-light \
"$TARGET"


echo
echo "[OK] Nmap completed"
