#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
OUTPUT="$2"

echo "RESOLVER"
echo "--------"

if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Input missing"
    exit 1
fi

if [ -z "$OUTPUT" ]; then
    echo "[ERROR] Output missing"
    exit 1
fi


resolve_doh()
{
    DOMAIN="$1"

    curl -s \
    "https://cloudflare-dns.com/dns-query?name=$DOMAIN&type=A" \
    -H "accept: application/dns-json"
}


get_ip()
{
    DOMAIN="$1"

    RESPONSE=$(resolve_doh "$DOMAIN")

    STATUS=$(echo "$RESPONSE" | grep -o '"Status":[0-9]*' | cut -d: -f2)

    if [ "$STATUS" = "0" ]; then

        IP=$(echo "$RESPONSE" \
        | grep -o '"data":"[0-9.]*"' \
        | head -1 \
        | cut -d'"' -f4)

        echo "$IP"
        return

    fi

    echo "N/A"
}


echo "Subdomain,IP,Sources,DNS_Status" > "$OUTPUT"


while IFS=',' read -r SUB IP SRC
do

    [ "$SUB" = "Subdomain" ] && continue


    if [ -z "$IP" ]; then

        RESOLVED=$(get_ip "$SUB")

        if [ "$RESOLVED" = "N/A" ]; then
            STATUS="NXDOMAIN"
        else
            STATUS="resolved"
        fi

        IP="$RESOLVED"

    else

        STATUS="known"

    fi


    echo "$SUB,$IP,$SRC,$STATUS" >> "$OUTPUT"


done < "$INPUT"


echo "[OK] Resolver completed"
