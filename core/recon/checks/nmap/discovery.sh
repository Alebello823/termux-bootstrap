#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"
OUTPUT="$2"

echo "NMAP DISCOVERY"
echo "--------------"

echo "[INFO] Discovering open ports"


nmap -Pn -T4 --open -p- "$TARGET" -oN "$OUTPUT"


echo "[OK] Discovery completed"
