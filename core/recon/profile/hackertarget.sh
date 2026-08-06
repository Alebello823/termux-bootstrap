#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"
OUTDIR="$2"

mkdir -p "$OUTDIR"

echo "HACKERTARGET"
echo "------------"

echo "[INFO] Downloading host search..."

TMP=$(mktemp)

if curl -fsS \
"https://api.hackertarget.com/hostsearch/?q=$TARGET" \
> "$TMP"; then

    if grep -q "," "$TMP"; then
        mv "$TMP" "$OUTDIR/hackertarget.txt"
    else
        echo "[WARN] No valid entries"
        rm -f "$TMP"
        exit 1
    fi

else
    echo "[ERROR] Hackertarget request failed"
    rm -f "$TMP"
    exit 1
fi

TOTAL=$(grep -c "," "$OUTDIR/hackertarget.txt")

echo "[INFO] Found $TOTAL entries"

echo "[OK] Hackertarget completed"
