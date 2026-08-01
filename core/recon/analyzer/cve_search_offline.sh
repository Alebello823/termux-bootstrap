#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# CVE SEARCH OFFLINE
# Usa base de datos local sin internet
# =====================================

CVE_DB="$HOME/termux-bootstrap/cache/cve_database.txt"

search_cve_offline() {
    local service="$1"
    local version="$2"
    
    echo "================================"
    echo " CVE SEARCH (OFFLINE MODE)"
    echo "================================"
    echo "[SERVICE] $service $version"
    echo
    
    if [ ! -f "$CVE_DB" ]; then
        echo "[ERROR] CVE database not found"
        echo "[INFO] Run: tb update --cve-db"
        return 1
    fi
    
    local found=0
    
    # Buscar por servicio
    echo "[*] Buscando CVEs para $service..."
    echo
    
    while IFS='|' read -r cve svc ver sev desc; do
        # Ignorar comentarios
        [[ "$cve" =~ ^#.*$ ]] && continue
        
        # Buscar coincidencias
        if echo "$svc" | grep -qi "$service"; then
            # Verificar si la versión está en rango
            if [ -n "$version" ] && echo "$ver" | grep -qE "[<>=]"; then
                # Aquí podrías añadir lógica de comparación de versiones
                echo "  🔴 $cve [$sev]"
                echo "     Service: $svc"
                echo "     Affected: $ver"
                echo "     Description: $desc"
                echo "     URL: https://nvd.nist.gov/vuln/detail/$cve"
                echo
                found=$((found + 1))
            elif [ -z "$version" ] || echo "$ver" | grep -q "$version"; then
                echo "  🟡 $cve [$sev]"
                echo "     Service: $svc"
                echo "     Affected: $ver"
                echo "     Description: $desc"
                echo "     URL: https://nvd.nist.gov/vuln/detail/$cve"
                echo
                found=$((found + 1))
            fi
        fi
    done < "$CVE_DB"
    
    echo "================================"
    echo " Total encontrado: $found CVEs"
    echo "================================"
    
    if [ $found -gt 0 ]; then
        echo
        echo "[!] Exploits disponibles:"
        echo "    tb exploit generate $service $version"
    fi
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    search_cve_offline "$1" "$2"
fi
