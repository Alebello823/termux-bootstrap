#!/data/data/com.termux/files/usr/bin/bash


INPUT="$1"
OUTPUT="$2"


if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Input missing"
    exit 1
fi


echo "Subdomain,IP,Sources,DNS_Status,Provider" > "$OUTPUT"


detect_provider()
{

IP="$1"


case "$IP" in

104.16.*|104.17.*|104.18.*|104.19.*|104.20.*|104.21.*|104.22.*|104.23.*|104.24.*|104.25.*|104.26.*|104.27.*|104.28.*|104.29.*|104.30.*|104.31.*)
    echo "Cloudflare"
    ;;

172.64.*|172.65.*|172.66.*|172.67.*)
    echo "Cloudflare"
    ;;

*)
    echo "Unknown"
    ;;

esac

}


while IFS=',' read -r SUB IP SRC STATUS
do

    [ "$SUB" = "Subdomain" ] && continue


    PROVIDER=$(detect_provider "$IP")


    echo "$SUB,$IP,$SRC,$STATUS,$PROVIDER" >> "$OUTPUT"


done < "$INPUT"


echo "[OK] Provider detection completed"
