#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

TARGET="$1"

[ -z "$TARGET" ] && {
    echo "[ERROR] Target missing"
    exit 1
}

REPORT_DIR="$BASE_DIR/reports/recon/$TARGET"
PROFILE="$REPORT_DIR/profile.txt"

mkdir -p "$REPORT_DIR"

########################################
# Funciones
########################################

get_http_server() {
    grep -i "^Server:" "$REPORT_DIR/http.txt" 2>/dev/null \
    | head -1 \
    | sed 's/^Server:[[:space:]]*//I'
}

get_php() {
    grep -oi 'PHP/[0-9.]*' "$REPORT_DIR/http.txt" 2>/dev/null \
    | head -1
}

is_cloudflare() {

    grep -qi cloudflare "$REPORT_DIR/http.txt" 2>/dev/null && {
        echo "Yes"
        return
    }

    grep -qi cloudflare "$REPORT_DIR/whatweb.txt" 2>/dev/null && {
        echo "Yes"
        return
    }

    echo "No"
}

########################################
# Construcción del perfil
########################################

echo "==================================" > "$PROFILE"
echo "TARGET PROFILE" >> "$PROFILE"
echo "==================================" >> "$PROFILE"
echo >> "$PROFILE"

echo "Target: $TARGET" >> "$PROFILE"

########################################
# IP
########################################

IP=""

if [ -f "$REPORT_DIR/dns.txt" ]; then
    IP=$(grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$REPORT_DIR/dns.txt" | head -1)
fi

[ -n "$IP" ] && echo "IP: $IP" >> "$PROFILE"

########################################
# Protección
########################################

echo "Cloudflare: $(is_cloudflare)" >> "$PROFILE"

########################################
# Tecnologías
########################################

SERVER=$(get_http_server)
PHP=$(get_php)

[ -n "$SERVER" ] && echo "Server: $SERVER" >> "$PROFILE"

[ -n "$PHP" ] && echo "PHP: $PHP" >> "$PROFILE"

########################################
# Servicios
########################################

if [ -f "$REPORT_DIR/nmap/services.txt" ]; then

    echo >> "$PROFILE"
    echo "Services:" >> "$PROFILE"

    grep -E '^[0-9]+/tcp' \
        "$REPORT_DIR/nmap/services.txt" \
        >> "$PROFILE"

fi

echo
echo "[OK] Target profile generated"
echo "$PROFILE"
