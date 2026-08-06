#!/data/data/com.termux/files/usr/bin/bash


DNS_ENDPOINT="https://cloudflare-dns.com/dns-query"


doh_query() {

    DOMAIN="$1"
    TYPE="$2"


    curl -s --max-time 5 \
    "$DNS_ENDPOINT?name=$DOMAIN&type=$TYPE" \
    -H "accept: application/dns-json"

}



doh_answers() {

    DOMAIN="$1"
    TYPE="$2"


    doh_query "$DOMAIN" "$TYPE" |
    grep -o '"data":"[^"]*"' |
    cut -d'"' -f4

}
