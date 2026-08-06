#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

source "$BASE_DIR/core/logger.sh" 2>/dev/null || true
source "$BASE_DIR/core/recon/cache.sh" 2>/dev/null || true


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
echo "[START] $(date '+%H:%M:%S')"
echo


####################################
# FASE 1
# FAST DISCOVERY
####################################

echo "[+] PHASE 1/4: PORT DISCOVERY"
echo "--------------------------------"


bash "$BASE_DIR/core/recon/checks/nmap/discovery.sh" \
"$TARGET" \
"$REPORT_DIR/discovery.txt"


if [ ! -f "$REPORT_DIR/discovery.txt" ]; then
    echo "[ERROR] Discovery file missing"
    exit 1
fi


####################################
# FASE 2
# PORT PARSER
####################################

echo
echo "[+] PHASE 2/4: PORT PARSING"
echo "--------------------------------"


PORTS=$(bash "$BASE_DIR/core/recon/checks/nmap/parser.sh" \
"$REPORT_DIR/discovery.txt")


if [ -z "$PORTS" ]; then

    echo "[WARN] No open ports detected"
    exit 0

fi


echo "[INFO] Open ports:"
echo "$PORTS"


echo "$PORTS" > "$REPORT_DIR/ports.txt"



####################################
# FASE 3
# SERVICE ENUMERATION
####################################

echo
echo "[+] PHASE 3/4: SERVICE ENUMERATION"
echo "--------------------------------"


bash "$BASE_DIR/core/recon/checks/nmap/service_scan.sh" \
"$TARGET" \
"$PORTS" \
"$REPORT_DIR"



####################################
# FASE 4
# PREPARE ANALYSIS
####################################

echo
echo "[+] PHASE 4/4: ANALYSIS PREPARATION"
echo "--------------------------------"


if [ -f "$REPORT_DIR/services.xml" ]; then

    echo "[OK] XML service database created"

bash "$BASE_DIR/core/recon/analyzer/nmap/cpe_extractor.sh" "$TARGET"

else

    echo "[WARN] services.xml missing"

fi



echo
echo "================================"
echo " NMAP COMPLETED"
echo "================================"


echo
echo "Generated files:"
ls -1 "$REPORT_DIR"


echo
echo "Report location:"
echo "$REPORT_DIR"
