#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
OUTPUT="$2"


if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Input missing"
    exit 1
fi


echo "[" > "$OUTPUT"

FIRST=true


while IFS=',' read -r SUB IP PROVIDER SCORE REASONS
do

    [ "$SUB" = "Subdomain" ] && continue


    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo "," >> "$OUTPUT"
    fi


cat >> "$OUTPUT" <<EOF
{
  "asset": "$SUB",
  "ip": "$IP",
  "provider": "$PROVIDER",
  "score": "$SCORE",
  "signals": "$REASONS"
}
EOF


done < "$INPUT"


echo "]" >> "$OUTPUT"


echo "[OK] Asset inventory generated"
