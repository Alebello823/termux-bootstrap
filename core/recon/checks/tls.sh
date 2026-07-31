#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

echo "TLS CHECK"
echo "---------"

if ! command -v openssl >/dev/null 2>&1
then
    echo "[WARN] openssl not installed"
    exit 0
fi

echo "[INFO] Certificate information"

echo | openssl s_client -connect "$TARGET:443" -servername "$TARGET" 2>/dev/null | \
openssl x509 -noout -issuer -subject -dates

echo

echo "[OK] TLS completed"
