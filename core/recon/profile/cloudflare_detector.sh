#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

echo "CLOUDFLARE DETECTOR"
echo "-------------------"

SCORE=0

echo "[*] Checking NS..."

if dig NS "$TARGET" +short | grep -qi cloudflare; then
    echo "[+] Cloudflare NS detected"
    SCORE=$((SCORE+30))
fi

echo

echo "[*] Checking HTTP headers..."

HEADERS=$(curl -skI "https://$TARGET")

for H in cf-ray cf-cache-status server; do

    if echo "$HEADERS" | grep -iq "$H"; then

        echo "[+] Header detected: $H"

        SCORE=$((SCORE+20))

    fi

done

echo

IP=$(dig +short "$TARGET" | head -1)

echo "[*] Target IP: $IP"

WHOIS=$(whois "$IP")

if echo "$WHOIS" | grep -Ei "cloudflare|13335" >/dev/null; then

    echo "[+] ASN Cloudflare"

    SCORE=$((SCORE+30))

fi

echo

echo "Confidence: $SCORE%"

if [ "$SCORE" -ge 60 ]; then

    echo "[RESULT] Cloudflare detected"

else

    echo "[RESULT] No evidence"

fi
