#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

echo "DNS CHECK"
echo "---------"

if ! command -v dig >/dev/null 2>&1
then
    echo "[WARN] dig not installed"
    exit 0
fi


echo "[INFO] A records"
timeout 5 dig "$TARGET" A +short


echo
echo "[INFO] MX records"
timeout 5 dig "$TARGET" MX +short


echo
echo "[INFO] NS records"
timeout 5 dig "$TARGET" NS +short


echo
echo "[OK] DNS completed"
