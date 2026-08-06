#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# NMAP WRAPPER
# ==========================================

NMAP_BIN=$(command -v nmap)

nmap_discovery() {
    local target="$1"
    local outfile="$2"

    "$NMAP_BIN" \
        -Pn \
        -n \
        -sT \
        --min-rate 1000 \
        --max-retries 2 \
        --defeat-rst-ratelimit \
        -oN "$outfile" \
        "$target"
}

nmap_services() {

    local target="$1"
    local ports="$2"
    local outfile="$3"

    "$NMAP_BIN" \
        -Pn \
        -sV \
        --version-intensity 7 \
        -p "$ports" \
        -oN "$outfile" \
        "$target"
}

nmap_scripts() {

    local target="$1"
    local ports="$2"
    local scripts="$3"
    local outfile="$4"

    "$NMAP_BIN" \
        -Pn \
        -sV \
        --script "$scripts" \
        -p "$ports" \
        -oN "$outfile" \
        "$target"
}
