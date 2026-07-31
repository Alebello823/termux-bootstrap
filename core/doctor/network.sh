#!/data/data/com.termux/files/usr/bin/bash

source "$(dirname "$0")/../logger.sh"

echo "=============================="
echo " NETWORK CHECK"
echo "=============================="

if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1
then
    echo "[OK] Internet connectivity"
else
    echo "[WARN] Internet unavailable"
fi


if command -v nslookup >/dev/null 2>&1
then
    echo "[INFO] DNS:"
    nslookup google.com | head
else
    echo "[WARN] nslookup not installed"
fi


log_info "Network check completed"
