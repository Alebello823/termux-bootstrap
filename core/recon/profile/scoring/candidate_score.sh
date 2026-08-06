#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
CLUSTERS="$2"
OUTPUT="$3"


if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Input missing"
    exit 1
fi


echo "Subdomain,IP,Provider,Score,Reasons" > "$OUTPUT"



while IFS=',' read -r SUB IP SRC STATUS PROVIDER
do

    [ "$SUB" = "Subdomain" ] && continue


    SCORE=0
    REASONS=""


    # Fuente múltiple
    if [[ "$SRC" == *"|"* ]]; then
        SCORE=$((SCORE+20))
        REASONS="${REASONS}multiple_sources;"
    fi


    # IP conocida
    if [ "$STATUS" = "known" ]; then
        SCORE=$((SCORE+20))
        REASONS="${REASONS}known_ip;"
    fi


    # IP resuelta
    if [ "$STATUS" = "resolved" ]; then
        SCORE=$((SCORE+10))
        REASONS="${REASONS}dns_resolved;"
    fi


    # Cloudflare resta prioridad
    if [ "$PROVIDER" = "Cloudflare" ]; then
        SCORE=$((SCORE-30))
        REASONS="${REASONS}cloudflare;"
    fi


    # Palabras interesantes
    if [ "$STATUS" != "NXDOMAIN" ]; then

    if echo "$SUB" | grep -Eqi "dev|test|stage|staging|beta|git|admin"; then
        SCORE=$((SCORE+15))
        REASONS="${REASONS}interesting_name;"
    fi

fi

# Correlación por IP

if [ -f "$CLUSTERS" ] && [ "$IP" != "N/A" ]; then

    COUNT=$(grep "^$IP," "$CLUSTERS" | awk -F',' '{print $NF}')

    if [ -n "$COUNT" ] && [ "$COUNT" -gt 1 ]; then

        if [ "$PROVIDER" = "Cloudflare" ]; then

            SCORE=$((SCORE+5))
            REASONS="${REASONS}shared_cdn;"

        else

            SCORE=$((SCORE+15))
            REASONS="${REASONS}shared_ip;"

        fi

    fi

fi

    # Limitar
    if [ "$SCORE" -lt 0 ]; then
        SCORE=0
    fi


    echo "$SUB,$IP,$PROVIDER,$SCORE,$REASONS" >> "$OUTPUT"


done < "$INPUT"



echo "[OK] Candidate scoring completed"
