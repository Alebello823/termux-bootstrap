#!/data/data/com.termux/files/usr/bin/bash

echo "PACKAGES CHECK"
echo "--------------"

if command -v pkg >/dev/null; then
    echo "[OK] Termux package manager available"
else
    echo "[ERROR] pkg unavailable"
fi

COUNT=$(pkg list-installed 2>/dev/null | wc -l)

echo "[INFO] Installed packages: $COUNT"
