#!/data/data/com.termux/files/usr/bin/bash


TARGET="$1"

CF_SCORE=0


check_cloudflare()
{

    echo "[INTEL] Cloudflare analysis" >&2


    # NS

    NS=$(timeout 5 dig NS "$TARGET" +short 2>/dev/null)

    if echo "$NS" | grep -qi cloudflare; then
        CF_SCORE=$((CF_SCORE+40))
        echo "[+] Cloudflare nameservers detected" >&2
    fi



    # HTTP headers

    HEADERS=$(timeout 10 curl -skI "https://$TARGET" 2>/dev/null)


    if echo "$HEADERS" | grep -qi "cloudflare"; then
        CF_SCORE=$((CF_SCORE+30))
        echo "[+] Cloudflare HTTP headers detected" >&2
    fi



    if echo "$HEADERS" | grep -qi "cf-ray"; then
        CF_SCORE=$((CF_SCORE+20)) >&2
        echo "[+] CF-Ray detected" >&2
    fi



    # IP ranges known

    IP=$(timeout 5 dig "$TARGET" A +short 2>/dev/null | head -1)


    case "$IP" in

        104.16.*|104.17.*|104.18.*|104.19.*|104.20.*|104.21.*|104.22.*|104.23.*|104.24.*|104.25.*|104.26.*|104.27.*|172.64.*|172.65.*|172.66.*|172.67.*)

            CF_SCORE=$((CF_SCORE+20))
            echo "[+] Cloudflare IP range detected" >&2

        ;;

    esac



    echo "$CF_SCORE"

}
