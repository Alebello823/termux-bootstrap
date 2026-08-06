#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "[ERROR] Target missing"
    echo "Uso: origin_discovery.sh dominio.com"
    exit 1
fi


REPORT_DIR="$BASE_DIR/reports/recon/$TARGET"

mkdir -p "$REPORT_DIR"

SUBFILE="$REPORT_DIR/subfinder.txt"
ORIGIN="$REPORT_DIR/origin_candidates.txt"


echo
echo "================================"
echo " ORIGIN DISCOVERY ENGINE"
echo "================================"
echo "[TARGET] $TARGET"
echo


#################################
# Cloudflare Detection
#################################

CF="false"


for FILE in \
"$REPORT_DIR/http.txt" \
"$REPORT_DIR/headers.txt" \
"$REPORT_DIR/whatweb.txt"
do

    if [ -f "$FILE" ]; then

        if grep -qi "cloudflare" "$FILE"; then
            CF="true"
        fi

    fi

done


if [ "$CF" != "true" ]; then

    echo "[INFO] Cloudflare not detected"
    echo "[INFO] No origin discovery required"

    exit 0

fi


echo "[+] Cloudflare detected"
echo


#################################
# Subfinder
#################################

if ! command -v subfinder >/dev/null 2>&1
then
    echo "[ERROR] subfinder not installed"
    exit 1
fi


echo "[+] Running subfinder..."

subfinder \
-d "$TARGET" \
-silent \
-o "$SUBFILE"


COUNT=$(wc -l < "$SUBFILE")


echo "[+] Subdomains found: $COUNT"
echo



#################################
# Resolve IPs
#################################

echo "================================"
echo " IP DISCOVERY"
echo "================================"


> "$ORIGIN"


while read SUB
do

    [ -z "$SUB" ] && continue


    IP=$(dig +short "$SUB" A | head -1)


    if [ -n "$IP" ]; then

        echo "$SUB -> $IP"

        echo "$SUB -> $IP" >> "$ORIGIN"

    fi


done < "$SUBFILE"



echo
echo "[OK] Results saved:"
echo "$ORIGIN"
