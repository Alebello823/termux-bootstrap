#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
OUTPUT="$2"


if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Classified inventory not found"
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
        read -r SCORE_LINE
        read -r SIGNAL_LINE
        read -r CLASS_LINE


        IP=$(echo "$IP_LINE" | cut -d'"' -f4)
        PROVIDER=$(echo "$PROVIDER_LINE" | cut -d'"' -f4)
        SCORE=$(echo "$SCORE_LINE" | cut -d'"' -f4)
        SIGNALS=$(echo "$SIGNAL_LINE" | cut -d'"' -f4)
        CLASS=$(echo "$CLASS_LINE" | cut -d'"' -f4)


        CONF=0
        EVIDENCE=""


        case "$CLASS" in

            DEVELOPMENT)
                CONF=$((CONF+30))
                EVIDENCE="${EVIDENCE}development_name;"
                ;;

            TESTING)
                CONF=$((CONF+30))
                EVIDENCE="${EVIDENCE}testing_name;"
                ;;

            STAGING)
                CONF=$((CONF+35))
                EVIDENCE="${EVIDENCE}staging_name;"
                ;;

            PRODUCTION)
                CONF=$((CONF+30))
                EVIDENCE="${EVIDENCE}production_name;"
                ;;

        esac


        if echo "$SIGNALS" | grep -q "multiple_sources"; then
            CONF=$((CONF+10))
            EVIDENCE="${EVIDENCE}multiple_sources;"
        fi


        if echo "$SIGNALS" | grep -q "known_ip"; then
            CONF=$((CONF+10))
            EVIDENCE="${EVIDENCE}known_ip;"
        fi


        if echo "$SIGNALS" | grep -q "shared_ip"; then
            CONF=$((CONF+15))
            EVIDENCE="${EVIDENCE}shared_ip;"
        fi


        if [ "$SCORE" -ge 50 ]; then
            CONF=$((CONF+20))
            EVIDENCE="${EVIDENCE}high_score;"
        fi


        if [ "$CONF" -gt 100 ]; then
            CONF=100
        fi



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
  "evidence": "$EVIDENCE"
}
EOF


    fi


done < "$INPUT"


echo "]" >> "$OUTPUT"


echo "[OK] Confidence analysis completed"
