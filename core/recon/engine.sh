#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

source "$BASE_DIR/core/recon/lib/module_runner.sh"
source "$BASE_DIR/core/recon/lib/common.sh"
source "$BASE_DIR/core/recon/lib/network.sh"
source "$BASE_DIR/core/recon/config.sh"
source "$BASE_DIR/core/recon/lib/nmap.sh"
source "$BASE_DIR/core/recon/lib/parser.sh"
source "$BASE_DIR/core/recon/lib/target_intelligence.sh" 2>/dev/null || true


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



####################################
# PASSIVE RECON
####################################


[ "$ENABLE_WHOIS" = true ] && \
run_module_safe "WHOIS" \
"$BASE_DIR/core/recon/checks/whois.sh"



[ "$ENABLE_DNS" = true ] && \
run_module_safe "DNS" \
"$BASE_DIR/core/recon/checks/dns.sh"



[ "$ENABLE_HTTP" = true ] && \
run_module_safe "HTTP" \
"$BASE_DIR/core/recon/checks/http.sh"



[ "$ENABLE_HEADERS" = true ] && \
run_module_safe "HEADERS" \
"$BASE_DIR/core/recon/checks/headers.sh"



[ "$ENABLE_TLS" = true ] && \
run_module_safe "TLS" \
"$BASE_DIR/core/recon/checks/tls.sh"



[ "$ENABLE_WHATWEB" = true ] && \
run_module_safe "WHATWEB" \
"$BASE_DIR/core/recon/checks/whatweb.sh"



echo



####################################
# TARGET INTELLIGENCE
####################################


echo "================================"
echo " TARGET INTELLIGENCE"
echo "================================"


CF_SCORE=0


if command -v check_cloudflare >/dev/null 2>&1; then

    CF_SCORE=$(check_cloudflare "$TARGET")

else

    if [ -f "$BASE_DIR/core/recon/lib/target_intelligence.sh" ]; then

        source "$BASE_DIR/core/recon/lib/target_intelligence.sh"

        CF_SCORE=$(check_cloudflare "$TARGET")

    fi

fi


echo "[INFO] Cloudflare confidence: $CF_SCORE%"


if [ "$CF_SCORE" -ge 60 ]; then


    echo "[!] CDN/WAF detected"

    echo "Cloudflare detected confidence=$CF_SCORE" \
    > "$REPORT_DIR/cloudflare.txt"


    echo "[!] Avoiding direct CDN IP scan"


    ENABLE_NMAP=false


fi



########################################
# TARGET SELECTION
########################################

echo
echo "================================"
echo " TARGET SELECTION"
echo "================================"

SCAN_TARGET="$TARGET"

# Si existe el selector inteligente usarlo
if [ -f "$BASE_DIR/core/recon/profile/origin_selector.sh" ]; then

    SELECTED=$(bash "$BASE_DIR/core/recon/profile/origin_selector.sh" "$TARGET")

    if [ -n "$SELECTED" ]; then
        SCAN_TARGET="$SELECTED"
    fi

fi

echo "[INFO] Scan target: $SCAN_TARGET"

TARGET_IP=$(resolve_target "$SCAN_TARGET")

if [ -z "$TARGET_IP" ]; then
    echo "[WARN] Could not resolve $SCAN_TARGET"
    TARGET_IP="$SCAN_TARGET"
fi

echo "[INFO] Final target: $TARGET_IP"

########################################
# NMAP
########################################

if [ "$ENABLE_NMAP" = true ]; then
    bash "$BASE_DIR/core/recon/checks/nmap/nmap.sh" "$TARGET_IP"
fi




####################################
# PROFILE
####################################


if [ -f "$BASE_DIR/core/recon/profile/profile_builder.sh" ]; then


    echo
    echo "========== TARGET PROFILE =========="


    bash \
    "$BASE_DIR/core/recon/profile/profile_builder.sh" \
    "$TARGET"


fi



####################################
# WEB ANALYSIS
####################################


if [ -f "$REPORT_DIR/nmap/discovery.txt" ]; then


    if grep -qE "80/tcp.*open|443/tcp.*open|8080/tcp.*open" \
    "$REPORT_DIR/nmap/discovery.txt"; then


        echo
        echo "[+] Web service detected"


        if [ -f "$BASE_DIR/core/recon/checks/web/webscan.sh" ]; then


            bash \
            "$BASE_DIR/core/recon/checks/web/webscan.sh" \
            "$TARGET"


        fi


    fi


fi



####################################
# FINISH
####################################


echo
echo "================================"
echo " RECON COMPLETED"
echo "================================"


echo
echo "Reports:"
echo "$REPORT_DIR"
