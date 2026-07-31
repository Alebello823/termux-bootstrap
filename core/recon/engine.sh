#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

source "$BASE_DIR/core/recon/config.sh"

TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "Uso:"
    echo "tb recon <target>"
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
        echo
        return
    fi

    bash "$SCRIPT" "$TARGET"

    echo

}

[ "$ENABLE_WHOIS" = true ] && \
run_module "WHOIS" "$BASE_DIR/core/recon/checks/whois.sh"

[ "$ENABLE_DNS" = true ] && \
run_module "DNS" "$BASE_DIR/core/recon/checks/dns.sh"

[ "$ENABLE_HTTP" = true ] && \
run_module "HTTP" "$BASE_DIR/core/recon/checks/http.sh"

[ "$ENABLE_HEADERS" = true ] && \
run_module "HEADERS" "$BASE_DIR/core/recon/checks/headers.sh"

[ "$ENABLE_TLS" = true ] && \
run_module "TLS" "$BASE_DIR/core/recon/checks/tls.sh"

[ "$ENABLE_WHATWEB" = true ] && \
run_module "WHATWEB" "$BASE_DIR/core/recon/checks/whatweb.sh"

[ "$ENABLE_NMAP" = true ] && \
run_module "NMAP" "$BASE_DIR/core/recon/checks/nmap/nmap.sh"

echo "================================"
echo " RECON COMPLETED"
echo "================================"
