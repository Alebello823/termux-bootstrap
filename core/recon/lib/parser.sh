#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# RECON PARSER LIBRARY
# Centraliza todo el parsing de Nmap
# =====================================

extract_ports() {

    local FILE="$1"

    grep -E '^[0-9]+/tcp' "$FILE" \
        | cut -d/ -f1 \
        | paste -sd,
}


    local FILE="$1"

    grep -Ei 'http|https|ssl/http|http-proxy' "$FILE" \
        | cut -d/ -f1 \
        | paste -sd,
}

extract_http_ports() {

    local FILE="$1"

    grep -E '^[0-9]+/tcp' "$FILE" \
    | grep -Ei 'http|https|ssl/http|http-proxy' \
    | cut -d/ -f1 \
    | paste -sd,
}

extract_services() {

    local FILE="$1"

    grep -E '^[0-9]+/tcp' "$FILE"
}

extract_versions() {

    local FILE="$1"

    grep -E '^[0-9]+/tcp' "$FILE" |
    while read LINE
    do

        PORT=$(echo "$LINE" | awk '{print $1}')
        SERVICE=$(echo "$LINE" | awk '{print $3}')

        VERSION=$(echo "$LINE" |
            cut -d' ' -f4-)

        echo "$PORT|$SERVICE|$VERSION"

    done
}

extract_ip() {

    local FILE="$1"

    grep "Nmap scan report" "$FILE" |
        grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' |
        head -1
}

extract_hostname() {

    local FILE="$1"

    grep "Nmap scan report" "$FILE" |
        sed 's/Nmap scan report for //g' |
        sed 's/(.*//g'
}
