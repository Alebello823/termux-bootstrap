#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

BASE_DIR="$HOME/termux-bootstrap"
CANDIDATES="$BASE_DIR/reports/recon/$TARGET/assets/candidates.csv"

if [ -z "$TARGET" ]; then
    exit 1
fi

BEST_TARGET="$TARGET"
BEST_SCORE=0

if [ ! -f "$CANDIDATES" ]; then
    echo "$BEST_TARGET"
    exit 0
fi

while IFS=',' read -r SUB IP PROVIDER SCORE REASONS
do
    # Saltar cabecera
    [ "$SUB" = "Subdomain" ] && continue

    # Sin IP
    [ "$IP" = "N/A" ] && continue

    # Ignorar Cloudflare
    [ "$PROVIDER" = "Cloudflare" ] && continue

    # Quedarse con la mayor puntuación
    if [ "$SCORE" -gt "$BEST_SCORE" ]; then
        BEST_SCORE="$SCORE"
        BEST_TARGET="$IP"
    fi

done < "$CANDIDATES"

echo "$BEST_TARGET"
