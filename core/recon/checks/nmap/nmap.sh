#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "[WARN] Target missing"
    exit 1
fi


REPORT_DIR="$BASE_DIR/reports/recon/$TARGET/nmap"

mkdir -p "$REPORT_DIR"


echo "================================"
echo " NMAP RECON ENGINE"
echo "================================"

echo "[TARGET] $TARGET"


echo
echo "[+] PORT DISCOVERY"
echo "-----------------"


bash "$BASE_DIR/core/recon/checks/nmap/discovery.sh" \
"$TARGET" \
"$REPORT_DIR/discovery.txt"


echo
echo "[+] PARSING OPEN PORTS"
echo "----------------------"


PORTS=$(bash "$BASE_DIR/core/recon/checks/nmap/parser.sh" \
"$REPORT_DIR/discovery.txt")


if [ -z "$PORTS" ]; then
    echo "[WARN] No open ports detected"
    exit 0
fi


echo "[INFO] Open ports:"
echo "$PORTS"


echo
echo "[+] SERVICE SCAN"
echo "----------------"


bash "$BASE_DIR/core/recon/checks/nmap/service_scan.sh" \
"$TARGET" \
"$PORTS" | tee "$REPORT_DIR/services.txt"


echo
echo "[OK] Nmap module completed"
