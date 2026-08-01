#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Network Library - Centralized
# =====================================

# Resolver target a IP (múltiples métodos, NO usa ping)
resolve_target() {
    local target="$1"
    local ip=""
    
    # Método 1: host
    if command -v host >/dev/null 2>&1; then
        ip=$(host "$target" 2>/dev/null | awk '/has address/{print $NF; exit}')
    fi
    
    # Método 2: dig
    if [ -z "$ip" ] && command -v dig >/dev/null 2>&1; then
        ip=$(dig +short "$target" A 2>/dev/null | head -1)
    fi
    
    # Método 3: nslookup
    if [ -z "$ip" ] && command -v nslookup >/dev/null 2>&1; then
        ip=$(nslookup "$target" 2>/dev/null | awk '/^Address: /{print $2}' | tail -1)
    fi
    
    # Método 4: Python socket
    if [ -z "$ip" ]; then
        ip=$(python3 -c "import socket; print(socket.gethostbyname('$target'))" 2>/dev/null)
    fi
    
    echo "$ip"
}

# Petición HTTP con timeout y fallback
http_request() {
    local target="$1"
    local timeout="${2:-15}"
    local retries="${3:-2}"
    
    # Intentar HTTPS primero, luego HTTP
    curl -k -I -L --connect-timeout 5 --max-time "$timeout" --retry "$retries" \
        "https://$target" 2>/dev/null || \
    curl -I -L --connect-timeout 5 --max-time "$timeout" --retry "$retries" \
        "http://$target" 2>/dev/null
}

# Obtener certificado TLS
get_certificate() {
    local target="$1"
    local timeout="${2:-10}"
    
    timeout "$timeout" openssl s_client -connect "${target}:443" -servername "$target" 2>/dev/null | \
        openssl x509 -noout -subject -issuer -dates 2>/dev/null
}
