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

# FASE 1: Port Discovery
if cache_exists "$TARGET" "nmap_discovery" 2>/dev/null; then
    echo "[INFO] Using cached discovery results"
    cache_load "$TARGET" "nmap_discovery" > "$REPORT_DIR/discovery.txt"
else
    echo "[+] PHASE 1/4: PORT DISCOVERY"
    echo "--------------------------------"
    bash "$BASE_DIR/core/recon/checks/nmap/discovery.sh" \
        "$TARGET" \
        "$REPORT_DIR/discovery.txt"
    cache_save "$TARGET" "nmap_discovery" < "$REPORT_DIR/discovery.txt" 2>/dev/null
fi

# FASE 2: Parse y Service Scan
echo
echo "[+] PHASE 2/4: SERVICE DETECTION"
echo "----------------------------------"

PORTS=$(bash "$BASE_DIR/core/recon/checks/nmap/parser.sh" \
    "$REPORT_DIR/discovery.txt")

if [ -z "$PORTS" ]; then
    echo "[WARN] No open ports detected on $TARGET"
    echo "[INFO] Target might be down or blocking scans"
    exit 0
fi

echo "[INFO] Open ports: $PORTS"

bash "$BASE_DIR/core/recon/checks/nmap/service_scan.sh" \
    "$TARGET" \
    "$PORTS" | tee "$REPORT_DIR/services.txt"

# FASE 3: Análisis Automático
echo
echo "[+] PHASE 3/4: VULNERABILITY ANALYSIS"
echo "---------------------------------------"

if [ -f "$BASE_DIR/core/recon/checks/nmap/analyze.sh" ]; then
    bash "$BASE_DIR/core/recon/checks/nmap/analyze.sh" "$TARGET"
else
    echo "[WARN] Analyze module not found"
    echo "[INFO] Install: tb update"
fi

# FASE 4: Reporte
echo
echo "[+] PHASE 4/4: GENERATING REPORT"
echo "----------------------------------"

if [ -f "$BASE_DIR/core/recon/reports/generate.sh" ]; then
    bash "$BASE_DIR/core/recon/reports/generate.sh" "$TARGET"
else
    # Reporte simple si no existe el generador
    {
        echo "=========================================="
        echo " NMAP SCAN REPORT"
        echo " Target: $TARGET"
        echo " Date: $(date)"
        echo "=========================================="
        echo
        echo "OPEN PORTS:"
        cat "$REPORT_DIR/discovery.txt" | grep "/tcp.*open"
        echo
        echo "FINDINGS:"
        cat "$REPORT_DIR/findings.txt" 2>/dev/null || echo "No automated findings"
    } > "$REPORT_DIR/scan_report.txt"
    
    echo "[OK] Basic report generated"
fi

echo
echo "================================"
echo " SCAN COMPLETED"
echo "================================"
echo "[END] $(date '+%H:%M:%S')"
echo
echo "📁 Reports saved in: $REPORT_DIR/"
ls -1 "$REPORT_DIR/" 2>/dev/null | while read f; do
    echo "  📄 $f"
done
echo
echo "💡 Next step: tb vuln $TARGET"
