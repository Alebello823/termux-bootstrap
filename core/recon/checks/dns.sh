#!/data/data/com.termux/files/usr/bin/bash


TARGET="$1"

REPORT_DIR="$HOME/termux-bootstrap/reports/recon/$TARGET"

mkdir -p "$REPORT_DIR"

DNS_OUTPUT="$REPORT_DIR/dns.txt"

BASE_DIR="$HOME/termux-bootstrap"

source "$BASE_DIR/core/recon/lib/dns.sh"



{
echo "DNS CHECK"
echo "---------"
} | tee "$DNS_OUTPUT"



echo "$A" | tee -a "$DNS_OUTPUT"

A=$(doh_answers "$TARGET" A)

if [ -n "$A" ]; then
    echo "$A"
else
    echo "[WARN] No A records"
fi



echo
echo "[INFO] MX records" | tee -a "$DNS_OUTPUT"

MX=$(doh_answers "$TARGET" MX)

if [ -n "$MX" ]; then
    echo "$MX"
else
    echo "[WARN] No MX records"
fi



echo
echo "[INFO] NS records" | tee -a "$DNS_OUTPUT"

NS=$(doh_answers "$TARGET" NS)

if [ -n "$NS" ]; then
    echo "$NS"
else
    echo "[WARN] No NS records"
fi



echo
echo "[OK] DNS completed" | tee -a "$DNS_OUTPUT"
