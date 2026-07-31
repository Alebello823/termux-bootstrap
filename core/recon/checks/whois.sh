#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

echo "WHOIS CHECK"
echo "-----------"

if ! command -v whois >/dev/null 2>&1
then
    echo "[WARN] whois not installed"
    exit 0
fi

echo "[INFO] Target: $TARGET"

whois "$TARGET" 2>/dev/null | head -40
