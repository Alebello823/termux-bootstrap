#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# CVE & Exploit Universal Lookup
# Busca vulnerabilidades para cualquier servicio
# =====================================

BASE_DIR="$HOME/termux-bootstrap"

lookup_cves_for_target() {
    local TARGET="$1"
    local SERVICES_FILE="$BASE_DIR/reports/recon/$TARGET/nmap/services.txt"
    
    echo "================================"
    echo " CVE & EXPLOIT LOOKUP"
    echo "================================"
    echo "[TARGET] $TARGET"
    echo "[TIME] $(date '+%H:%M:%S')"
    echo
    
    if [ ! -f "$SERVICES_FILE" ]; then
        echo "[ERROR] No service scan found for $TARGET"
        echo "[INFO] Run first: tb scan $TARGET"
        exit 1
    fi
    
    # Extraer servicios y versiones únicos
    local services=$(grep -oP '\d+/tcp\s+open\s+\K\S+' "$SERVICES_FILE" | sort -u)
    
    if [ -z "$services" ]; then
        echo "[ERROR] No services detected"
        exit 1
    fi
    
    echo "[INFO] Services found:"
    echo "$services" | while read s; do echo "  • $s"; done
    echo
    
    # Para cada servicio, buscar CVEs
    for service in $services; do
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🔍 Searching: $service"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # searchsploit
        if command -v searchsploit >/dev/null 2>&1; then
            echo "[*] ExploitDB (searchsploit):"
            searchsploit "$service" 2>/dev/null | head -10 || echo "  No results"
            echo
        else
            echo "[!] searchsploit not installed"
            echo "    Install: pkg install exploitdb"
            echo
        fi
        
        # nmap vuln scripts
        if command -v nmap >/dev/null 2>&1; then
            echo "[*] Nmap NSE scripts for $service:"
            ls /data/data/com.termux/files/usr/share/nmap/scripts/ 2>/dev/null | \
                grep -i "$service" | head -5 || echo "  No scripts found"
            echo
        fi
        
        echo
    done
    
    echo "================================"
    echo " LOOKUP COMPLETED"
    echo "================================"
    echo
    echo "💡 Detailed exploit search:"
    echo "   tb vuln --service <name> <version>"
}

search_specific_service() {
    local SERVICE="$1"
    local VERSION="$2"
    
    echo "================================"
    echo " EXPLOIT SEARCH"
    echo "================================"
    echo "[SERVICE] $SERVICE"
    echo "[VERSION] $VERSION"
    echo
    
    # searchsploit
    if command -v searchsploit >/dev/null 2>&1; then
        echo "[+] ExploitDB Results:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        searchsploit "$SERVICE $VERSION" 2>/dev/null
        echo
    fi
    
    # Buscar en nmap scripts
    if command -v nmap >/dev/null 2>&1; then
        echo "[+] Nmap NSE Scripts for $SERVICE:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        nmap --script-help "$SERVICE-*" 2>/dev/null | grep -E "Categories:|\.nse" | head -10
        echo
    fi
    
    # Metasploit (si existe)
    if [ -f "$HOME/metasploit-framework/msfconsole" ]; then
        echo "[+] Metasploit modules:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        $HOME/metasploit-framework/msfconsole -q -x "search $SERVICE; exit" 2>/dev/null | \
            grep -v "^$" | grep -v "msf6" | head -15
        echo
    fi
    
    echo "================================"
    echo "[OK] Search completed"
}

# Main
case "$1" in
    --service)
        shift
        search_specific_service "$1" "$2"
        ;;
    *)
        if [ -z "$1" ]; then
            echo "Uso: $0 <target>                    # Analizar objetivo"
            echo "     $0 --service <name> <version>   # Buscar exploits"
            exit 1
        fi
        lookup_cves_for_target "$1"
        ;;
esac
