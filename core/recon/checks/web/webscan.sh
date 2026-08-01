#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Web Vulnerability Scan Module
# Se activa al detectar HTTP/HTTPS
# =====================================

BASE_DIR="$HOME/termux-bootstrap"
TARGET="$1"
PORT="${2:-80}"

if [ -z "$TARGET" ]; then
    echo "[WARN] Target missing"
    exit 1
fi

echo "================================"
echo " WEB VULNERABILITY SCANNER"
echo "================================"
echo "[TARGET] $TARGET:$PORT"
echo

REPORT_DIR="$BASE_DIR/reports/recon/$TARGET/web"
mkdir -p "$REPORT_DIR"

# Usar SIEMPRE el standalone
if [ -f "$BASE_DIR/exploits/generated/http_scanner_standalone.py" ]; then
    python3 "$BASE_DIR/exploits/generated/http_scanner_standalone.py" "$TARGET" | tee "$REPORT_DIR/web_scan.txt"
elif [ -f "$BASE_DIR/core/recon/checks/web/http_vuln_scanner.py" ]; then
    python3 "$BASE_DIR/core/recon/checks/web/http_vuln_scanner.py" "$TARGET" "$PORT" | tee "$REPORT_DIR/web_scan.txt"
fi

echo "[OK] Web scan completed"
echo "Report: $REPORT_DIR/web_scan.txt"
