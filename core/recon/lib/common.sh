#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Common Functions Library
# =====================================

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funciones de output
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

section() {
    echo
    echo "================================"
    echo " $1"
    echo "================================"
}

# Logging
LOG_DIR="$HOME/termux-bootstrap/logs"
mkdir -p "$LOG_DIR"

log() {
    local level="$1"
    local message="$2"
    local logfile="$LOG_DIR/recon.log"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$logfile"
}

# Dispatcher centralizado
run_module() {
    local name="$1"
    local script="$2"
    
    echo
    echo "========== $name =========="
    
    if [ ! -f "$script" ]; then
        warn "Module not found: $script"
        log "WARN" "Module not found: $name ($script)"
        return 1
    fi
    
    timeout "${MODULE_TIMEOUT:-60}" bash "$script" "$TARGET"
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        success "$name completed"
        log "OK" "$name completed (exit: $exit_code)"
    elif [ $exit_code -eq 124 ]; then
        warn "$name timed out"
        log "WARN" "$name timed out"
    else
        warn "$name failed (exit: $exit_code)"
        log "ERROR" "$name failed (exit: $exit_code)"
    fi
    
    return $exit_code
}
