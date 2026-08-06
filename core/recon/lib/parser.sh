#!/data/data/com.termux/files/usr/bin/bash

extract_ports() {
    local FILE="$1"
    grep -E '^[0-9]+/tcp' "$FILE" | cut -d/ -f1 | paste -sd,
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

extract_ip() {
    local FILE="$1"
    grep "Nmap scan report" "$FILE" \
        | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' \
        | head -1
}
