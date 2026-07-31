#!/data/data/com.termux/files/usr/bin/bash

set -e

BASE_DIR="$HOME/termux-bootstrap"
LOG="$BASE_DIR/install.log"

echo "================================="
echo " Termux Bootstrap Installer"
echo "================================="

echo "[+] Iniciando instalación..." | tee -a "$LOG"

source "$BASE_DIR/lib/system.sh"
source "$BASE_DIR/lib/repair.sh"
source "$BASE_DIR/lib/packages.sh"
source "$BASE_DIR/lib/golang.sh"
source "$BASE_DIR/lib/python.sh"
source "$BASE_DIR/lib/security.sh"
source "$BASE_DIR/lib/verify.sh"

check_system
repair_termux
install_packages
setup_go
setup_python
install_security_tools
verify_installation

echo "[+] Instalación terminada"
