#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"

if [ ! -f "$INPUT" ]; then
    echo "[WARN] Nmap output not found"
    exit 1
fi

grep "/tcp" "$INPUT" | \
grep "open" | \
awk '{print $1}' | \
cut -d/ -f1 | \
paste -sd "," -
