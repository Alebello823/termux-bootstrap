#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
OUTPUT="$2"

if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Inventory not found"
    exit 1
fi

echo "[" > "$OUTPUT"

FIRST=true


extract_value() {
    echo "$1" | sed 's/[",]//g' | awk -F': ' '{print $2}'
}


while read -r line
do

    [ -z "$line" ] && continue


    if echo "$line" | grep -q '"asset"'; then

        ASSET=$(echo "$line" | cut -d'"' -f4)

        read -r IP_LINE
        read -r PROVIDER_LINE
        read -r SCORE_LINE
        read -r SIGNAL_LINE


        IP=$(echo "$IP_LINE" | cut -d'"' -f4)
        PROVIDER=$(echo "$PROVIDER_LINE" | cut -d'"' -f4)
        SCORE=$(echo "$SCORE_LINE" | cut -d'"' -f4)
        SIGNALS=$(echo "$SIGNAL_LINE" | cut -d'"' -f4)


        TYPE="UNKNOWN"


        case "$ASSET" in

            dev.*|*-dev*|*-development*)
                TYPE="DEVELOPMENT"
                ;;

            test.*|*-test*)
                TYPE="TESTING"
                ;;

            *stage*|*staging*)
                TYPE="STAGING"
                ;;

            prod.*|*production*)
                TYPE="PRODUCTION"
                ;;

            www.*)
                TYPE="PRODUCTION"
                ;;

            api.*)
                TYPE="API"
                ;;

            mail.*)
                TYPE="MAIL"
                ;;

            git*|gitlab*)
                TYPE="DEVELOPMENT"
                ;;

            vpn*)
                TYPE="ACCESS"
                ;;

        esac


        if [ "$FIRST" = true ]; then
            FIRST=false
        else
            echo "," >> "$OUTPUT"
        fi


cat >> "$OUTPUT" <<EOF
{
  "asset": "$ASSET",
  "ip": "$IP",
  "provider": "$PROVIDER",
  "score": "$SCORE",
  "signals": "$SIGNALS",
  "classification": "$TYPE"
}
EOF

    fi


done < "$INPUT"


echo "]" >> "$OUTPUT"


echo "[OK] Inventory classification completed"
