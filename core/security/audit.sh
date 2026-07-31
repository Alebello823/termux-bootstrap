#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

echo "================================"
echo " TERMUX SECURITY AUDIT"
echo "================================"

echo

echo "[+] Checking environment"

if [ -d "$HOME/.ssh" ]; then
    echo "[OK] SSH directory exists"
else
    echo "[INFO] No SSH directory"
fi


echo

echo "[+] Checking permissions"

bash "$BASE_DIR/core/security/checks/permissions.sh"


echo

echo "[+] Checking packages"

bash "$BASE_DIR/core/security/checks/packages.sh"


echo

echo "[OK] Security audit completed"
