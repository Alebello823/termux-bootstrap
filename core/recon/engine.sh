#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"
source "$BASE_DIR/core/recon/config.sh"

TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "Uso: tb recon <target>"
    exit 1
fi

REPORT_DIR="$BASE_DIR/reports/recon/$TARGET"
mkdir -p "$REPORT_DIR"

echo "================================"
echo " TERMUX RECON ENGINE"
echo "================================"
echo "[TARGET] $TARGET"
echo

run_module(){
    NAME="$1"
    SCRIPT="$2"
    if [ ! -f "$SCRIPT" ]; then
        echo "[WARN] Missing module: $NAME"
        return
    fi
    bash "$SCRIPT" "$TARGET"
    echo
}

# Módulos de reconocimiento pasivo
[ "$ENABLE_WHOIS" = true ] && run_module "WHOIS" "$BASE_DIR/core/recon/checks/whois.sh"
[ "$ENABLE_DNS" = true ] && run_module "DNS" "$BASE_DIR/core/recon/checks/dns.sh"
[ "$ENABLE_HTTP" = true ] && run_module "HTTP" "$BASE_DIR/core/recon/checks/http.sh"
[ "$ENABLE_HEADERS" = true ] && run_module "HEADERS" "$BASE_DIR/core/recon/checks/headers.sh"
[ "$ENABLE_TLS" = true ] && run_module "TLS" "$BASE_DIR/core/recon/checks/tls.sh"
[ "$ENABLE_WHATWEB" = true ] && run_module "WHATWEB" "$BASE_DIR/core/recon/checks/whatweb.sh"

# Nmap (principal)
[ "$ENABLE_NMAP" = true ] && run_module "NMAP" "$BASE_DIR/core/recon/checks/nmap/nmap.sh"

# Web scan automático si se detectó HTTP
if [ -f "$REPORT_DIR/nmap/discovery.txt" ]; then
    if grep -qE "80/tcp.*open|443/tcp.*open|8080/tcp.*open" "$REPORT_DIR/nmap/discovery.txt" 2>/dev/null; then
        echo "[+] Web server detected - Running web vulnerability scan..."
        
        if grep -q "443/tcp.*open" "$REPORT_DIR/nmap/discovery.txt"; then
            WEB_PORT=443
        elif grep -q "8080/tcp.*open" "$REPORT_DIR/nmap/discovery.txt"; then
            WEB_PORT=8080
        else
            WEB_PORT=80
        fi
        
        if [ -f "$BASE_DIR/core/recon/checks/web/webscan.sh" ]; then
            bash "$BASE_DIR/core/recon/checks/web/webscan.sh" "$TARGET" "$WEB_PORT"
        else
            python3 "$BASE_DIR/exploits/generated/http_scanner_standalone.py" "$TARGET" 2>/dev/null
        fi
        echo
    fi
fi

# Auto-generar exploits para servicios críticos
if [ -f "$REPORT_DIR/nmap/services.txt" ] && [ -f "$BASE_DIR/core/recon/analyzer/exploit_hunter.sh" ]; then
    echo "[+] Generating exploits for detected services..."
    
    # Extraer servicios y versiones
    grep -E "open.*ssh|open.*http|open.*ftp|open.*smb" "$REPORT_DIR/nmap/services.txt" 2>/dev/null | \
    while read line; do
        service=$(echo "$line" | awk '{print $3}')
        version=$(echo "$line" | awk '{$1=$2=$3=""; print $0}' | grep -oP '\d+\.\d+[^\s]*' | head -1)
        port=$(echo "$line" | awk '{print $1}' | cut -d'/' -f1)
        
        if [ -n "$version" ]; then
            bash "$BASE_DIR/core/recon/analyzer/exploit_hunter.sh" generate "$service" "$version" "$port" 2>/dev/null
        fi
    done
    echo
fi

echo "================================"
echo " RECON COMPLETED"
echo "================================"
echo
echo "Resumen de archivos generados:"
echo "  Reports: $REPORT_DIR"
echo "  Exploits: $BASE_DIR/exploits/generated/"
echo "  Wordlists: $BASE_DIR/cache/wordlists/"
echo
echo "Próximos pasos:"
echo "  tb vuln $TARGET          # Buscar CVEs"
echo "  tb report $TARGET        # Ver reporte ejecutivo"
