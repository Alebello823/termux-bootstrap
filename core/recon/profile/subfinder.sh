#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"
OUTDIR="$2"

mkdir -p "$OUTDIR"

echo "SUBFINDER"
echo "---------"

if ! command -v subfinder >/dev/null 2>&1; then
    echo "[WARN] subfinder not installed"
    exit 0
fi

echo "[INFO] Enumerating subdomains..."

subfinder \
    -d "$TARGET" \
    -silent \
    | sort -u \
    > "$OUTDIR/subfinder.txt"

TOTAL=$(wc -l < "$OUTDIR/subfinder.txt")

echo "[INFO] Found $TOTAL subdomains"

echo "[OK] Subfinder completed"
