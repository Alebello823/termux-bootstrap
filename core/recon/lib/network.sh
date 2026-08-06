#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Network Library - Centralized
# Resolver + HTTP + TLS
# =====================================


# Resolver target a IP
resolve_target() {

    local target="$1"
    local ip=""

    if [ -z "$target" ]; then
        echo ""
        return
    fi


    # HOST
    if command -v host >/dev/null 2>&1; then

        ip=$(timeout 5 host "$target" 2>/dev/null \
        | awk '/has address/ {print $NF; exit}')

    fi



    # DIG fallback
    if [ -z "$ip" ] && command -v dig >/dev/null 2>&1; then

        ip=$(timeout 5 dig +short A "$target" 2>/dev/null \
        | grep -E '^[0-9]+\.' \
        | head -1)

    fi



    # NSLOOKUP fallback
    if [ -z "$ip" ] && command -v nslookup >/dev/null 2>&1; then

        ip=$(timeout 5 nslookup "$target" 2>/dev/null \
        | awk '/^Address: / {print $2}' \
        | grep -E '^[0-9]+\.' \
        | tail -1)

    fi



    # Python fallback
    if [ -z "$ip" ]; then

        ip=$(timeout 5 python3 - <<EOF
import socket
try:
 print(socket.gethostbyname("$target"))
except:
 pass
EOF
)

    fi



    # Validación

    if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "$ip"
    else
        echo ""
    fi

}




# =====================================
# HTTP Request
# =====================================

http_request() {

    local target="$1"
    local timeout="${2:-15}"



    timeout "$timeout" curl \
    -k \
    -I \
    -L \
    --connect-timeout 5 \
    --max-time "$timeout" \
    --retry 1 \
    "https://$target" 2>/dev/null



    if [ $? -ne 0 ]; then

        timeout "$timeout" curl \
        -I \
        -L \
        --connect-timeout 5 \
        --max-time "$timeout" \
        --retry 1 \
        "http://$target" 2>/dev/null

    fi

}




# =====================================
# TLS Certificate
# =====================================

get_certificate() {

    local target="$1"
    local timeout="${2:-10}"


    timeout "$timeout" \
    openssl s_client \
    -connect "${target}:443" \
    -servername "$target" \
    </dev/null 2>/dev/null \
    | openssl x509 \
    -noout \
    -subject \
    -issuer \
    -dates 2>/dev/null

}
