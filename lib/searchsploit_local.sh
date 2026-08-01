#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# searchsploit local minimalista
# Sin necesidad de clonar el repo completo
# =====================================

EXPLOIT_DB="$HOME/termux-bootstrap/cache/exploitdb"
mkdir -p "$EXPLOIT_DB"

search_exploit() {
    local query="$1"
    
    echo "🔍 Buscando exploits para: $query"
    echo "=================================="
    
    # Si no existe la base de datos CSV, descargarla
    if [ ! -f "$EXPLOIT_DB/files_exploits.csv" ]; then
        echo "[*] Descargando base de datos de exploits..."
        curl -L --retry 5 --retry-delay 10 \
            -o "$EXPLOIT_DB/files_exploits.csv" \
            https://raw.githubusercontent.com/offensive-security/exploitdb/master/files_exploits.csv
    fi
    
    # Si no existe, usar searchsploit online via curl
    if [ -f "$EXPLOIT_DB/files_exploits.csv" ]; then
        echo "[*] Buscando en base de datos local..."
        grep -i "$query" "$EXPLOIT_DB/files_exploits.csv" | head -20
    else
        echo "[*] Buscando online..."
        curl -s "https://www.exploit-db.com/search?q=$query" | \
            grep -oP 'href="/exploits/\K[^"]+' | head -10
    fi
}

search_exploit "$1"
