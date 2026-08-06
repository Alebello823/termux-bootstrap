#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
OUTPUT="$2"


if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Confidence inventory missing"
    exit 1
fi


echo "[" > "$OUTPUT"

FIRST=true


while read -r line
do

    [ -z "$line" ] && continue


    if echo "$line" | grep -q '"asset"'; then


        ASSET=$(echo "$line" | cut -d'"' -f4)

        read -r IP_LINE
        read -r PROVIDER_LINE
        read -r CLASS_LINE
        read -r CONF_LINE
        read -r EVIDENCE_LINE


        IP=$(echo "$IP_LINE" | cut -d'"' -f4)
        PROVIDER=$(echo "$PROVIDER_LINE" | cut -d'"' -f4)
        CLASS=$(echo "$CLASS_LINE" | cut -d'"' -f4)
        CONF=$(echo "$CONF_LINE" | cut -d'"' -f4)
        EVIDENCE=$(echo "$EVIDENCE_LINE" | cut -d'"' -f4)


        PRIORITY="LOW"
        RISK="Normal asset"


        if [ "$CONF" -ge 80 ]; then
            PRIORITY="HIGH"
        elif [ "$CONF" -ge 50 ]; then
            PRIORITY="MEDIUM"
        fi


        case "$CLASS" in

            DEVELOPMENT)
                RISK="Exposed development asset"
                ;;

            TESTING)
                RISK="Testing environment exposed"
                ;;

            STAGING)
                RISK="Staging environment exposed"
                ;;

            PRODUCTION)
                RISK="Production asset"
                ;;

            MAIL)
                RISK="Mail infrastructure"
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
  "classification": "$CLASS",
  "confidence": "$CONF",
  "priority": "$PRIORITY",
  "risk": "$RISK",
  "evidence": "$EVIDENCE"
}
EOF


    fi

done < "$INPUT"


echo "]" >> "$OUTPUT"


echo "[OK] Asset intelligence generated"
