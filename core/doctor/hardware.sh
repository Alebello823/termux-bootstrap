#!/data/data/com.termux/files/usr/bin/bash

source "$(dirname "$0")/../logger.sh"

echo "=============================="
echo " HARDWARE CHECK"
echo "=============================="

echo "[INFO] Arquitectura: $(uname -m)"
echo "[INFO] Kernel: $(uname -r)"

if command -v free >/dev/null 2>&1; then
    echo "[INFO] RAM:"
    free -h
fi

echo "[INFO] Almacenamiento:"
df -h "$HOME"

log_info "Hardware check completed"
