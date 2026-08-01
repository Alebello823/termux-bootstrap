#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Universal Nmap Post-Scan Analyzer
# Funciona con cualquier servicio/versión
# =====================================

BASE_DIR="$HOME/termux-bootstrap"

analyze_nmap_results() {
    local TARGET="$1"
    local REPORT_DIR="$BASE_DIR/reports/recon/$TARGET/nmap"
    local SERVICES_FILE="$REPORT_DIR/services.txt"
    local DISCOVERY_FILE="$REPORT_DIR/discovery.txt"
    local FINDINGS_FILE="$REPORT_DIR/findings.txt"
    local ACTIONS_FILE="$REPORT_DIR/suggested_actions.txt"
    
    echo "================================"
    echo " VULNERABILITY ANALYSIS"
    echo "================================"
    echo "[TARGET] $TARGET"
    echo "[TIME] $(date '+%H:%M:%S')"
    echo
    
    # Inicializar archivos
    > "$FINDINGS_FILE"
    > "$ACTIONS_FILE"
    
    local total_findings=0
    
    # =============================================
    # FASE 1: Análisis de antigüedad de servicios
    # =============================================
    echo "[+] PHASE 1: Service Age Analysis"
    echo "--------------------------------"
    
    if [ ! -f "$SERVICES_FILE" ]; then
        echo "[WARN] No service scan results found"
        echo "[INFO] Run full nmap scan first: tb scan $TARGET"
        return 1
    fi
    
    # Extraer cada servicio con su versión
    while IFS= read -r line; do
        # Buscar líneas con servicio detectado
        if echo "$line" | grep -qE '^[0-9]+/tcp.*open.*[0-9]+\.[0-9]+'; then
            local port=$(echo "$line" | awk '{print $1}' | cut -d'/' -f1)
            local service=$(echo "$line" | awk '{print $3}')
            local version_info=$(echo "$line" | awk '{$1=$2=$3=""; print $0}' | sed 's/^[ \t]*//')
            
            echo "[*] Analyzing: $service on port $port"
            echo "    Version: $version_info"
            
            # Determinar antigüedad por número de versión mayor
            local major_version=$(echo "$version_info" | grep -oP '\d+' | head -1)
            local risk="INFO"
            local score=0
            
            if [ -n "$major_version" ] && [ "$major_version" -lt 3 ] 2>/dev/null; then
                risk="CRITICAL"
                score=95
                echo "    [!!] CRITICAL: Very old version detected (major=$major_version)"
                echo "CRITICAL|$service|$port|$version_info|Very old software (v$major_version)|CVE search recommended" >> "$FINDINGS_FILE"
                total_findings=$((total_findings + 1))
            elif [ -n "$major_version" ] && [ "$major_version" -lt 5 ] 2>/dev/null; then
                risk="HIGH"
                score=70
                echo "    [!] HIGH: Old version detected (major=$major_version)"
                echo "HIGH|$service|$port|$version_info|Old software version|Check for updates" >> "$FINDINGS_FILE"
                total_findings=$((total_findings + 1))
            elif [ -n "$major_version" ] && [ "$major_version" -lt 8 ] 2>/dev/null; then
                risk="MEDIUM"
                score=40
                echo "    * MEDIUM: Consider updating (major=$major_version)"
                echo "MEDIUM|$service|$port|$version_info|Update recommended|Check release notes" >> "$FINDINGS_FILE"
                total_findings=$((total_findings + 1))
            else
                echo "    ✅ Version appears recent"
            fi
            
            echo
        fi
    done < "$SERVICES_FILE"
    
    # =============================================
    # FASE 2: Detección de servicios peligrosos
    # =============================================
    echo "[+] PHASE 2: Dangerous Service Detection"
    echo "----------------------------------------"
    
    if [ -f "$DISCOVERY_FILE" ]; then
        # Telnet (siempre crítico)
        if grep -q "23/tcp.*open" "$DISCOVERY_FILE"; then
            echo "[!!] CRITICAL: Telnet detected on port 23 (plaintext protocol)"
            echo "CRITICAL|telnet|23|unknown|Plaintext protocol - credentials exposed|Disable immediately" >> "$FINDINGS_FILE"
            total_findings=$((total_findings + 1))
        fi
        
        # FTP sin TLS
        if grep -q "21/tcp.*open" "$DISCOVERY_FILE" && ! grep -q "ftps\|sftp" "$SERVICES_FILE" 2>/dev/null; then
            echo "[!] HIGH: FTP detected on port 21"
            echo "HIGH|ftp|21|unknown|FTP without encryption|Use SFTP instead" >> "$FINDINGS_FILE"
            total_findings=$((total_findings + 1))
        fi
        
        # Puertos de bases de datos expuestos
        if grep -qE "3306/tcp|5432/tcp|27017/tcp|6379/tcp" "$DISCOVERY_FILE"; then
            echo "[!] HIGH: Database port exposed directly"
            local db_ports=$(grep -E "3306/tcp|5432/tcp|27017/tcp|6379/tcp" "$DISCOVERY_FILE" | awk '{print $1}')
            for db_port in $db_ports; do
                echo "HIGH|database|${db_port%/*}|unknown|Database directly exposed|Restrict with firewall" >> "$FINDINGS_FILE"
                total_findings=$((total_findings + 1))
            done
        fi
        
        # Puertos comúnmente asociados a backdoors
        if grep -qE "31337/tcp|4444/tcp|1337/tcp|6667/tcp" "$DISCOVERY_FILE"; then
            echo "* MEDIUM: Suspicious port detected (possible backdoor)"
            local susp_ports=$(grep -E "31337/tcp|4444/tcp|1337/tcp|6667/tcp" "$DISCOVERY_FILE" | awk '{print $1}')
            for susp_port in $susp_ports; do
                echo "MEDIUM|suspicious|${susp_port%/*}|unknown|Non-standard port - possible backdoor|Investigate process" >> "$FINDINGS_FILE"
                total_findings=$((total_findings + 1))
            done
        fi
        echo
    fi
    
    # =============================================
    # FASE 3: Sugerencia de próximos pasos
    # =============================================
    echo "[+] PHASE 3: Recommended Actions"
    echo "--------------------------------"
    
    if [ -f "$DISCOVERY_FILE" ]; then
        # Servicios web
        if grep -qE "80/tcp|443/tcp|8080/tcp|8443/tcp" "$DISCOVERY_FILE"; then
            echo " WEB SERVICES DETECTED:"
            echo "   → whatweb scan: tb scan $TARGET --web"
            echo "   → Directory fuzzing: gobuster dir -u http://$TARGET"
            echo " WEB" >> "$ACTIONS_FILE"
            echo
        fi
        
        # SSH
        if grep -q "22/tcp" "$DISCOVERY_FILE"; then
            echo " SSH DETECTED:"
            echo "   → Audit SSH config: ssh-audit $TARGET"
            echo "   → Check weak credentials: hydra -l root -P wordlist.txt ssh://$TARGET"
            echo " SSH" >> "$ACTIONS_FILE"
            echo
        fi
        
        # SMB/NetBIOS
        if grep -qE "445/tcp|139/tcp" "$DISCOVERY_FILE"; then
            echo " SMB DETECTED:"
            echo "   → Enumerate shares: smbclient -L //$TARGET"
            echo "   → Check vulnerabilities: nmap --script smb-vuln* $TARGET"
            echo " SMB" >> "$ACTIONS_FILE"
            echo
        fi
    fi
    
    # =============================================
    # RESUMEN
    # =============================================
    echo "================================"
    echo " ANALYSIS SUMMARY"
    echo "================================"
    echo "Total findings: $total_findings"
    echo
    echo "Reports saved:"
    echo "  • $FINDINGS_FILE"
    echo "  • $ACTIONS_FILE"
    echo
    
    if [ $total_findings -gt 0 ]; then
        echo "🔍 Run detailed CVE search:"
        echo "   tb vuln $TARGET"
    fi
    
    return 0
}

# Ejecución directa
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    if [ -z "$1" ]; then
        echo "Uso: $0 <target>"
        exit 1
    fi
    analyze_nmap_results "$1"
fi
