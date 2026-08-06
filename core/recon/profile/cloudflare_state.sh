#!/data/data/termux/files/usr/bin/bash

TARGET="$1"

BASE_DIR="$HOME/termux-bootstrap"

REPORT_DIR="$BASE_DIR/reports/recon/$TARGET"
STATE="$REPORT_DIR/cloudflare_state.txt"

mkdir -p "$REPORT_DIR"

SCORE=0


echo "[*] Checking Cloudflare state"


echo "[*] Checking NS..."

NS=$(timeout 5 dig NS "$TARGET" +short 2>/dev/null)

if echo "$NS" | grep -qi cloudflare; then
    SCORE=$((SCORE+30))
fi


echo "[*] Checking HTTP headers..."

HEADERS=$(timeout 8 curl -skI "https://$TARGET" 2>/dev/null)


if echo "$HEADERS" | grep -qi cloudflare; then
    SCORE=$((SCORE+30))
fi


if echo "$HEADERS" | grep -qi "cf-ray"; then
    SCORE=$((SCORE+20))
fi


echo "Cloudflare_Score=$SCORE" > "$STATE"


if [ "$SCORE" -ge 60 ]; then
    echo "Cloudflare=true" >> "$STATE"
else
    echo "Cloudflare=false" >> "$STATE"
fi


echo "[OK] Cloudflare state generated"
cat "$STATE"
