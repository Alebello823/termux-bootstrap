#!/data/data/termux/files/usr/bin/bash

TARGET="$1"
PORTS="$2"
OUTPUT_DIR="$3"


echo "NMAP SERVICE ENUMERATION"
echo "------------------------"


if [ -z "$TARGET" ] || [ -z "$PORTS" ]; then
    echo "[WARN] Missing arguments"
    exit 1
fi


mkdir -p "$OUTPUT_DIR"


echo "[INFO] Target: $TARGET"
echo "[INFO] Ports: $PORTS"


nmap \
-Pn \
-sT \
-sV \
-sC \
--script vuln \
-p "$PORTS" \
"$TARGET" \
-oN "$OUTPUT_DIR/services.txt" \
-oX "$OUTPUT_DIR/services.xml"



if [ $? -eq 0 ]; then

    echo "[OK] Service scan completed"

else

    echo "[ERROR] Service scan failed"
    exit 1

fi
