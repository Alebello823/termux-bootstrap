#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
OUTPUT="$2"

if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Inventory not found"
    exit 1
fi

echo "[" > "$OUTPUT"

FIRST=true

while read -r line
do

    ASSET=$(echo "$line" | grep '"asset"' | cut -d'"' -f4)

    [ -z "$ASSET" ] && continue


    TYPE="UNKNOWN"


    case "$ASSET" in

        dev.*|*-dev*|*-development*)
            TYPE="DEVELOPMENT"
            ;;

        *test*)
            TYPE="TESTING"
            ;;

        *stage*|*staging*)
            TYPE="STAGING"
            ;;

        *prod*)
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

        git*)
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
  "classification": "$TYPE"
}
EOF


done < "$INPUT"


echo "]" >> "$OUTPUT"


echo "[OK] Asset classification completed"
